library(data.table)
library(xgboost)
library(caret)
library(lubridate)
library(fastDummies)
library(SHAPforxgboost)
library(data.table)
library(phsopendata)  
library(dplyr)
library(lubridate)
library(ranger)       
library(arrow)
library(glue)
library(httr)
library(jsonlite)
library(readr)
library(httr)
library(purrr)
library(stringr)
library(tidyr)

# Load data
url <- "https://www.opendata.nhs.scot/dataset/weekly-accident-and-emergency-activity-and-waiting-times/resource/a5f7ca94-c810-41b5-a7c9-25c18d43e5a4/download/weekly_a&e_activity_waiting_times.csv"
df <- fread(url)

#### Date Cleaning 

df <- df %>%
  mutate(
    WeekEndingDate = lubridate::ymd(WeekEndingDate),
    MonthNum = lubridate::month(WeekEndingDate),
    WeekNum = lubridate::week(WeekEndingDate),
    Year = lubridate::year(WeekEndingDate)
  ) %>% 
  select(-Country) ### Removes country before encoding and factoring starts, this whole column would just be 1 once encoded so pointless to keep it.

# Convert categorical variables to factors
cat_cols <- c("HBT", "DepartmentType", "AttendanceCategory", "TreatmentLocation")
df[, (cat_cols) := lapply(.SD, as.factor), .SDcols = cat_cols]

# Sort for lag
df <- df[order(HBT, TreatmentLocation, AttendanceCategory, WeekEndingDate)]

# Lag previous week attendances
df[, `:=`(
  Lag1  = shift(NumberOfAttendancesEpisode, 1),
  Lag2  = shift(NumberOfAttendancesEpisode, 2),
  Lag3  = shift(NumberOfAttendancesEpisode, 3),
  Lag4  = shift(NumberOfAttendancesEpisode, 4),
  Lag12 = shift(NumberOfAttendancesEpisode, 12),  # ~3 months
  Lag26 = shift(NumberOfAttendancesEpisode, 26),  # ~6 months
  Lag52 = shift(NumberOfAttendancesEpisode, 52)   # 1 year seasonality
), by = .(HBT, TreatmentLocation)]

df[, RollMean_4 := frollmean(NumberOfAttendancesEpisode, 4, align = "right"),
   by = .(HBT, TreatmentLocation)]

df[, RollMean_12 := frollmean(NumberOfAttendancesEpisode, 12, align = "right"),
   by = .(HBT, TreatmentLocation)]

df[, `:=`(
  Week_sin = sin(2*pi*WeekNum/52),
  Week_cos = cos(2*pi*WeekNum/52),
  Month_sin = sin(2*pi*MonthNum/12),
  Month_cos = cos(2*pi*MonthNum/12)
)]

df[, `:=`(
  Diff_1 = NumberOfAttendancesEpisode - Lag1,
  PctChange_1 = (NumberOfAttendancesEpisode - Lag1) / Lag1
), by = .(HBT, TreatmentLocation)]

df[, Winter := as.integer(MonthNum %in% c(12,1,2))]

df <- df[!is.na(Lag52)]

# One-hot encode categorical variables on the full dataset
df <- dummy_cols(df, select_columns = cat_cols, remove_first_dummy = FALSE, remove_selected_columns = FALSE) ### remove_selected_columns = FALSE is here so we can join the predictions back on at the end

cutoff_date <- as.Date("2024-12-31") #### End of 2024

# Split data based on date
train_data <- df[WeekEndingDate <= cutoff_date]
test_data  <- df[WeekEndingDate > cutoff_date]


test_meta <- test_data[, .(WeekEndingDate, HBT, DepartmentType, AttendanceCategory, TreatmentLocation, NumberOfAttendancesEpisode)] # Dataset created without encoding so we can join predictions on at the end.

test_data <- test_data %>% 
  select(-HBT, -DepartmentType, -AttendanceCategory, -TreatmentLocation) ### Removes these columns as these are taken into test_meta and won't be needed by the model

train_data <- train_data %>% 
  select(-HBT, -DepartmentType, -AttendanceCategory, -TreatmentLocation)### Removes these columns as these are taken into test_meta and won't be needed by the model

###########################
#### Data Cleaning Over ###
###########################



predictor_cols <- setdiff(names(train_data), c("NumberOfAttendancesEpisode", "WeekEndingDate"))

dtrain <- xgb.DMatrix(data = as.matrix(train_data[, ..predictor_cols]), label = train_data$NumberOfAttendancesEpisode)
dtest  <- xgb.DMatrix(data = as.matrix(test_data[, ..predictor_cols]),  label = test_data$NumberOfAttendancesEpisode)


params <- list(
  objective = "reg:squarederror",
  eval_metric = "rmse",
  eta = 0.03,              # smaller learning rate
  max_depth = 3,           # shallower trees
  min_child_weight = 10,   # require more data per leaf
  gamma = 1,               # require gain to split
  subsample = 0.8,
  colsample_bytree = 0.8
)

model <- xgb.train(
  params = params,
  data = dtrain,
  nrounds = 500,
  evals = list(train = dtrain, test = dtest), 
  early_stopping_rounds = 20,
  print_every_n = 50
)

preds <- predict(model, dtest)
rmse <- RMSE(preds, test_data$NumberOfAttendancesEpisode)
r2   <- R2(preds, test_data$NumberOfAttendancesEpisode)
cat("RMSE:", rmse, "\n")
cat("R²:", r2, "\n")


importance_matrix <- xgb.importance(model = model)
print(importance_matrix)
xgb.plot.importance(importance_matrix)


test_meta[, Predicted_Attendance := preds]

# Inspect
head(test_meta[, .(WeekEndingDate, HBT, TreatmentLocation, NumberOfAttendancesEpisode, Predicted_Attendance)])

test_meta_cleaned <- test_meta %>%
  mutate(
    Predicted_Attendance = ifelse(Predicted_Attendance < 0, 0, Predicted_Attendance),
    Residual = NumberOfAttendancesEpisode - Predicted_Attendance
  )

###########################
#### Forecasting Begins ###
###########################
