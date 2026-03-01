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

df <- df[AttendanceCategory == "Unplanned"]
df <- df %>% 
  select(-NumberWithin4HoursEpisode, -NumberOver4HoursEpisode, NumberOver12HoursEpisode, -NumberOver8HoursEpisode, -NumberOver12HoursEpisode, -PercentageWithin4HoursEpisode, -PercentageOver8HoursEpisode, -PercentageOver12HoursEpisode)

df <- df %>%
  mutate(
    WeekEndingDate = lubridate::ymd(WeekEndingDate),
    MonthNum = lubridate::month(WeekEndingDate),
    WeekNum = lubridate::week(WeekEndingDate),
    Year = lubridate::year(WeekEndingDate)
  ) %>% 
  select(-Country) ### Removes country before encoding and factoring starts, this whole column would just be 1 once encoded so pointless to keep it.

# Convert categorical variables to factors
cat_cols <- c("HBT", "DepartmentType", "TreatmentLocation")
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
), by = .(HBT, DepartmentType, TreatmentLocation)]

df[, RollMean_4 := frollmean(NumberOfAttendancesEpisode, 4, align = "right"),
   by = .(HBT, DepartmentType, TreatmentLocation)]

df[, RollMean_12 := frollmean(NumberOfAttendancesEpisode, 12, align = "right"),
   by = .(HBT, DepartmentType, TreatmentLocation)]

df[, `:=`(
  Week_sin = sin(2*pi*WeekNum/52),
  Week_cos = cos(2*pi*WeekNum/52),
  Month_sin = sin(2*pi*MonthNum/12),
  Month_cos = cos(2*pi*MonthNum/12)
)]


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
  nrounds = 2000,
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

last_date <- max(df$WeekEndingDate)
future_weeks <- seq(last_date + 7, by = 7, length.out = 12)

future_base <- df %>%
  select(HBT, DepartmentType, AttendanceCategory, TreatmentLocation) %>%
  distinct()

future_base <- as.data.table(future_base)

# Cross join ONLY weeks onto real combinations
future_data <- future_base[
  , .(WeekEndingDate = future_weeks),
  by = .(HBT, DepartmentType, TreatmentLocation)
]

future_data <- as.data.table(future_data)

# Keep full engineered dataset (before removing NA Lag52)
history_dt <- copy(df)
real_history <- copy(df)   # df after full feature engineering

forecast_results <- list()

forecast_results <- list()

for (i in 1:12) {
  
  next_week <- max(history_dt$WeekEndingDate) + 7
  
  setorder(history_dt,
           HBT,
           DepartmentType,
           TreatmentLocation,
           WeekEndingDate)
  
  history_dt[, `:=`(
    Lag1  = shift(NumberOfAttendancesEpisode, 1),
    Lag2  = shift(NumberOfAttendancesEpisode, 2),
    Lag3  = shift(NumberOfAttendancesEpisode, 3),
    Lag4  = shift(NumberOfAttendancesEpisode, 4),
    Lag12 = shift(NumberOfAttendancesEpisode, 12),
    Lag26 = shift(NumberOfAttendancesEpisode, 26),
    Lag52 = shift(NumberOfAttendancesEpisode, 52)
  ), by = .(HBT, DepartmentType, TreatmentLocation)]
  
  history_dt[, RollMean_4 :=
               frollmean(NumberOfAttendancesEpisode, 4, align = "right"),
             by = .(HBT, DepartmentType, TreatmentLocation)]
  
  history_dt[, RollMean_12 :=
               frollmean(NumberOfAttendancesEpisode, 12, align = "right"),
             by = .(HBT, DepartmentType, TreatmentLocation)]
  
  last_rows <- history_dt[
    , .SD[.N],
    by = .(HBT, DepartmentType, TreatmentLocation)
  ]
  
  new_rows <- copy(last_rows)
  
  new_rows[, WeekEndingDate := next_week]
  
  new_rows_enc <- dummy_cols(
    new_rows,
    select_columns = cat_cols,
    remove_first_dummy = FALSE,
    remove_selected_columns = FALSE
  )
  
  new_rows_matrix <- as.matrix(new_rows_enc[, ..predictor_cols])
  preds_future <- predict(model, new_rows_matrix)
  
  new_rows[, NumberOfAttendancesEpisode := preds_future]
  
  history_dt <- rbind(history_dt, new_rows, fill = TRUE)
  
  forecast_results[[i]] <- new_rows
}

future_forecast <- rbindlist(forecast_results)

future_forecast[, Predicted_Attendance := NumberOfAttendancesEpisode]

future_forecast <- future_forecast[
  , .(WeekEndingDate, HBT, DepartmentType,
      TreatmentLocation, Predicted_Attendance)
]


