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
df <- df[order(HBT, TreatmentLocation, WeekEndingDate)]

# Lag previous week attendances
df[, Lag1_Attendance := shift(NumberOfAttendancesEpisode, 1, type="lag"), by=.(HBT, TreatmentLocation)]

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
  eta = 0.05,
  max_depth = 5,
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

last_date <- max(test_meta_cleaned$WeekEndingDate)

last_lag <- test_meta_cleaned %>%
  group_by(WeekEndingDate ,HBT, DepartmentType, AttendanceCategory, TreatmentLocation) %>%
  summarise(Lag1_Attendance = last(Predicted_Attendance), .groups = "drop")%>%
  mutate(WeekEndingDate = WeekEndingDate + 7)



future_weeks <- seq.Date(
  from = last_date + 7,         # start the week after the last date
  to   = last_date + 365,       # 1 year ahead
  by   = "week"
)

future_weeks

future_data <- test_meta_cleaned %>%
  select(HBT, DepartmentType, AttendanceCategory, TreatmentLocation) %>%
  slice(rep(1:n(), each = length(future_weeks))) %>%
  mutate(
    WeekEndingDate = rep(future_weeks, times = nrow(test_meta_cleaned)),
    WeekNum = week(WeekEndingDate),
    MonthNum = month(WeekEndingDate),
    Year = year(WeekEndingDate)
  ) %>% 
  distinct()

future_data <- future_data %>%
  left_join(last_lag, by = c("HBT", "DepartmentType", "AttendanceCategory", "TreatmentLocation", "WeekEndingDate"))

future_data <- future_data %>%
  arrange(HBT, DepartmentType, AttendanceCategory, TreatmentLocation, WeekEndingDate)


future_data <- dummy_cols(future_data, select_columns = cat_cols, remove_first_dummy = FALSE, remove_selected_columns = FALSE)

# Create storage for forecasts
future_data$Predicted_Attendance <- NA

missing_cols <- setdiff(predictor_cols, names(future_data))
if (length(missing_cols) > 0) {
  future_data[, (missing_cols) := 0]  # add missing columns as 0
}

setDT(future_data)

future_data <- future_data %>%
  arrange(HBT,
          DepartmentType,
          AttendanceCategory,
          TreatmentLocation,
          WeekEndingDate)

unique_weeks <- sort(unique(future_data$WeekEndingDate))

for (i in seq_along(unique_weeks)) {
  
  wk <- unique_weeks[i]
  
  week_rows <- which(future_data$WeekEndingDate == wk)
  
  week_matrix <- as.matrix(future_data[week_rows, ..predictor_cols])
  
  preds <- pmax(predict(model, week_matrix), 0)
  
  future_data$Predicted_Attendance[week_rows] <- preds
  
  if (i < length(unique_weeks)) {
    
    next_week_rows <- which(future_data$WeekEndingDate == unique_weeks[i + 1])
    
    # SAFE because ordering is identical within each week
    future_data$Lag1_Attendance[next_week_rows] <- preds
  }
}