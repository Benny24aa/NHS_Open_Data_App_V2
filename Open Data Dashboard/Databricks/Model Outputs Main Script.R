#### Script Setup ###


# --- Load libraries ---
library(data.table)
library(phsopendata)   # For live PHS data
library(dplyr)
library(lubridate)
library(ranger)        # Much faster alternative to randomForest
library(arrow)
library(glue)
library(httr)
library(jsonlite)
library(readr)

###### Define the type of model you wish to run, this could be Alpha, Beta, Charlie, or Delta.

model_type <- "Alpha"

##### Yes or No to this question - If you have ran the data cleaning process before, press Yes so you don't have to go through it again for the training data

train_data_in_environment <- "No" ## Note some models have slightly different cleaning processes, so only say yes if you want to run the same model twice with other hyper parameters 

# "none"	No variable importance computed (fastest).
# "impurity"	Gini impurity decrease (classification) or variance decrease (regression). Fast, but biased toward variables with many categories.
# "impurity_corrected"	Bias-corrected impurity importance. Slower but more reliable than plain impurity.
# "permutation"	Permutation importance. Measures drop in prediction accuracy when a variable is permuted. Reliable but slower.

importance_type <- "impurity"

# We look at 5, 10, 20, 50 and 100 for the number of trees

tree_number <- 5

##### Decide if you want to save the output of the model you have ran. No or Yes

save_output <- "Yes"

##### Decide if you want to merge the outputs together so you can place them onto databricks - note you have to move the files yourself 

merge_outputs <- "No"

#### This creates plotly graphs and soon a rmarkdown to look at model quality metrics

further_analytics <- "Yes"

###### Data extraction started

file_path <- "Databricks/presdisp.parquet"

needs_refresh <- TRUE

if (file.exists(file_path)) {
  
  file_age_days <- as.numeric(
    difftime(Sys.time(), file.info(file_path)$mtime, units = "days")
  )
  
  print(file_age_days)  # <- keep this while debugging
  
  if (file_age_days < 28) {
    needs_refresh <- FALSE
    message("Parquet file is current — no refresh needed.")
  }
}

if (needs_refresh) {
  
  message("Refreshing prescribed-dispensed dataset...")
  
  presdisp <- get_dataset("prescribed-dispensed", include_context = TRUE) %>% 
    filter(ResID != "31576bf0-fc05-49ff-a99a-2c253a0c3342") %>% ### Most recent quarter data is in here, this is removed to avoid duplicates with current years data
    select(-ResName, -ResID, -ResCreatedDate, -ResModifiedDate)
  
  write_parquet(presdisp, file_path)
  
  message("Dataset refreshed and saved.")
}


if (train_data_in_environment == "No") {

####### Preparing Data for Random Forest Model of Choice

# --- Load main prescribing dataset ---
df <- read_parquet("Databricks/presdisp.parquet")


# Convert PrescriberLocation to numeric
df$PrescriberLocation <- as.numeric(df$PrescriberLocation)

##### Gathering most recent GP Practice Data 
###### This part allows for only OPEN locations to be in the model. So the model will only run for sites that are still open today using the last 8 years worth of train data.


# GP Practice Contact Details and List Sizes
dataset_id <- "f23655c3-6e23-4103-a511-a80d998adb90"

api_url <- paste0(
  "https://www.opendata.nhs.scot/api/3/action/package_show?id=",
  dataset_id
)

# Fetch metadata
res <- GET(api_url)
stop_for_status(res)

meta <- content(res, as = "text", encoding = "UTF-8") |>
  fromJSON(flatten = TRUE)

resources <- meta$result$resources

# Keep only CSV files
csv_resources <- resources |>
  filter(grepl("csv", format, ignore.case = TRUE))

# Convert created timestamp to datetime and arrange newest first
csv_resources <- csv_resources |>
  mutate(created = as.POSIXct(created, tz = "UTC")) |>
  arrange(desc(created))

if (nrow(csv_resources) == 0) {
  stop("No CSV resources found.")
}

# Select most recent CSV
latest_csv <- csv_resources[1, ]

### For my own use - Testing
cat("Latest dataset detected:\n")
cat("Name:", latest_csv$name, "\n")
cat("Created:", latest_csv$created, "\n")
cat("URL:", latest_csv$url, "\n\n")

# Load into R
gp_list <- read_csv(latest_csv$url) ### This is now the most recent gp list on the NHS Open Data Website.


##### Big GP list - Bringing in all PracticeSizeLists over the years.


dataset_id <- "f23655c3-6e23-4103-a511-a80d998adb90"

api_url <- paste0(
  "https://www.opendata.nhs.scot/api/3/action/package_show?id=",
  dataset_id
)

res <- GET(api_url)
stop_for_status(res)

meta <- content(res, as = "text", encoding = "UTF-8") |>
  fromJSON(flatten = TRUE)

resources <- meta$result$resources

csv_resources <- resources |>
  filter(grepl("csv", format, ignore.case = TRUE)) |>
  filter(grepl("GP", name, ignore.case = TRUE))


extract_date_info <- function(name) {
  
  match <- str_extract(
    name,
    "(January|February|March|April|May|June|July|August|September|October|November|December)\\s+\\d{4}"
  )
  
  if (is.na(match)) {
    return(tibble(month = NA_character_,
                  year  = NA_integer_,
                  date  = as.Date(NA)))
  }
  
  date_parsed <- my(match)
  
  tibble(
    month = month(date_parsed, label = TRUE, abbr = FALSE),
    year  = year(date_parsed),
    date  = date_parsed
  )
}

csv_resources <- csv_resources |>
  mutate(date_info = map(name, extract_date_info)) |>
  unnest(date_info) |>
  filter(!is.na(date)) |>
  arrange(date)


data_list <- map2(
  csv_resources$url,
  csv_resources$date,
  ~ read_csv(
    .x,
    col_types = cols(.default = col_character()),  # <-- KEY FIX
    show_col_types = FALSE
  ) |>
    mutate(
      month = month(.y, label = TRUE, abbr = FALSE),
      year  = year(.y),
      date  = .y
    )
)



all_gp_data <- bind_rows(data_list)


if ("PracticeListSize" %in% names(all_gp_data)) {
  all_gp_data <- all_gp_data |>
    mutate(
      PracticeListSize = parse_number(PracticeListSize)
    )
}

all_gp_data <- all_gp_data |>
  arrange(date)

all_gp_data <- all_gp_data %>% 
  select(PracticeCode, PracticeListSize, Listsize, month, year, date )

all_gp_data <- all_gp_data %>%
  mutate(
    PracticeListSize = coalesce(
      readr::parse_number(as.character(PracticeListSize)),
      readr::parse_number(as.character(Listsize))
    )
  ) 

all_gp_data_cleaned <- all_gp_data %>% 
  select(-Listsize) %>% 
  mutate(PracticeCode = as.numeric(PracticeCode))


if (model_type != "Beta") {
# --- Load GP practice list and join ---
gp_list <- gp_list %>%
  select(PracticeCode, HB, HSCP, DataZone, GPCluster, PracticeListSize) %>%
  distinct() %>%
  rename(PrescriberLocation = PracticeCode) }

if (model_type == "Beta") {
  # --- Load GP practice list ---
  gp_list <- gp_list %>% 
    select(PracticeCode, HB, HSCP, DataZone, GPCluster, PracticeListSize, GPPracticeName, AddressLine1, AddressLine2, AddressLine3, Postcode, PracticeType) %>%
    distinct() %>%
    rename(PrescriberLocation = PracticeCode)
}

# --- Load GP age profile ---
gp_further_info <- get_resource(res_id = "ac5a7a66-7bf9-4ea0-b076-a0de9fb71ad6") %>%
  filter(Sex == "All") %>%
  select(-ends_with("QF")) %>%
  rename_with(~ gsub("Ages", "", .x)) %>%
  rename_with(~ gsub("plus", "85to99", .x)) %>%
  rename_with(~ gsub("to", "-", .x))

get_col <- function(x) {
  if (x %in% colnames(gp_further_info)) gp_further_info[[x]]
  else rep(0, nrow(gp_further_info))
}

### Bringing in ages from gp_further_info

gp_further_info <- gp_further_info %>%
  mutate(
    age_0_19  = get_col("00-04") + get_col("05-09") + get_col("10-14") + get_col("15-19"),
    age_20_29 = get_col("20-24") + get_col("25-29"),
    age_30_65 = get_col("30-34") + get_col("35-39") + get_col("40-44") +
      get_col("45-49") + get_col("50-54") + get_col("55-59") + get_col("60-64"),
    age_65_plus = get_col("65-69") + get_col("70-74") + get_col("75-79") +
      get_col("80-84") + get_col("8585-99")
  ) %>%
  select(PracticeCode, age_0_19, age_20_29, age_30_65, age_65_plus) %>%
  rename(PrescriberLocation = PracticeCode)

gp_list <- left_join(gp_list, gp_further_info, by = "PrescriberLocation")

# --- Filter GP prescribing ---
df <- df %>%
  filter(
    PrescriberLocationType == "GP PRACTICE",
    DispenserLocationType == "COMMUNITY PHARMACY"
  )

  # Join to GP metadata
  df <- left_join(gp_list, df, by = "PrescriberLocation")

########################

if (model_type == "Alpha") {
   df <- df %>%
    select(PaidDateMonth, PrescriberLocation, PrescriberLocationType,
           DispenserLocation, DispenserLocationType, NumberOfPaidItems,
           HB, HSCP, DataZone, GPCluster, PracticeListSize, age_0_19, age_20_29, age_30_65, age_65_plus)
}

if (model_type == "Beta") {
  df <- df %>%
  select(
    PaidDateMonth, PrescriberLocation, DispenserLocation, NumberOfPaidItems,
    HB, HSCP, GPCluster, PracticeListSize,
    age_0_19, age_20_29, age_30_65, age_65_plus, GPPracticeName, AddressLine1, AddressLine2, AddressLine3, Postcode, PracticeType, PrescriberType
  )
}

if (model_type %in% c("Charlie", "Delta")) {
  df <- df %>%
    select(PaidDateMonth, PrescriberLocation, PrescriberLocationType,
           DispenserLocation, DispenserLocationType, NumberOfPaidItems,
           HB, HSCP, DataZone, GPCluster, PracticeListSize, age_0_19, age_20_29, age_30_65, age_65_plus, PrescriberType)
}

df <- df %>%
  mutate(
    PaidDateMonth = lubridate::ym(PaidDateMonth),
    MonthNum = lubridate::month(PaidDateMonth),
    Year = lubridate::year(PaidDateMonth)
  )


if (model_type == "Beta") {
  df <- df %>%
    mutate(log_items = log1p(NumberOfPaidItems))
}




if (model_type != "Delta") {
 # --- Convert to data.table for speed ---
    setDT(df)

  # --- Train fast random forest model (ranger) ---
  set.seed(123)
}

if (model_type == "Delta") {
  
  factor_vars <- c("HB", "HSCP", "GPCluster", "PrescriberType")
  
  
  # --- Convert to data.table for speed ---
  setDT(df)
  
  df[, (factor_vars) := lapply(.SD, as.factor), .SDcols = factor_vars]
}




if (model_type == "Beta") {
  factor_vars <- c(
    "GPCluster", "HSCP", "HB",
    "PrescriberLocation", "DispenserLocation",
    "MonthNum", "GPPracticeName",
    "AddressLine1", "AddressLine2", "AddressLine3",
    "Postcode", "PracticeType", "PrescriberType"
  )
  
  # Convert all in one go
  df[, (factor_vars) := lapply(.SD, as.factor), .SDcols = factor_vars]
  
}

#### Breaking Test Data and Main Data up

test_Df <- df %>% 
  filter(PaidDateMonth >= ym("2025-01"))

df <- df %>%
  filter(PaidDateMonth < ym("2025-01"))

}

##### Data Cleaning Section Done


##### Modelling Starts

if (model_type == "Beta") { 
  
  rf_model <- ranger(
    log_items ~
      MonthNum +
      PracticeListSize +
      age_0_19 + age_20_29 + age_30_65 + age_65_plus + GPCluster + HSCP + HB +
      PrescriberLocation + DispenserLocation + GPPracticeName + AddressLine1 + AddressLine2 + AddressLine3 + Postcode + PracticeType + PrescriberType,
    data = df,
    num.trees = tree_number,
    min.node.size = 1,
    max.depth = 30,
    mtry = 7,
    importance = importance_type,
    num.threads = 2
  )
  
} else if (model_type %in% c("Alpha", "Charlie", "Delta")) {
  
  # Define predictors for each model
  predictors <- switch(model_type,
                       Alpha   = c("MonthNum", "PaidDateMonth", "PracticeListSize",
                                   "age_0_19", "age_20_29", "age_30_65", "age_65_plus",
                                   "GPCluster", "HSCP", "DataZone", "HB",
                                   "PrescriberLocation", "DispenserLocation"),
                       Charlie = c("MonthNum", "PaidDateMonth", "PracticeListSize",
                                   "age_0_19", "age_20_29", "age_30_65", "age_65_plus",
                                   "GPCluster", "HSCP", "DataZone", "HB",
                                   "PrescriberLocation", "DispenserLocation", "PrescriberType"),
                       Delta   = c("MonthNum", "PaidDateMonth", "PracticeListSize",
                                   "age_0_19", "age_20_29", "age_30_65", "age_65_plus",
                                   "GPCluster", "HSCP", "DataZone", "HB",
                                   "PrescriberType")
  )
  
  # Build formula dynamically
  rf_formula <- as.formula(paste("NumberOfPaidItems ~", paste(predictors, collapse = " + ")))
  
  # Run ranger
  rf_model <- ranger(
    formula = rf_formula,
    data = df,
    num.trees = tree_number,
    importance = importance_type,
    num.threads = 2
  )
}

if (model_type == "Alpha") {
  test_Df <- test_Df %>%
    select(PaidDateMonth, PrescriberLocation, PrescriberLocationType,
           DispenserLocation, DispenserLocationType, NumberOfPaidItems,
           HB, HSCP, DataZone, GPCluster, PracticeListSize, age_0_19, age_20_29, age_30_65, age_65_plus, Year, MonthNum)
}

if (model_type == "Beta") {
  test_Df <- test_Df %>% 
  select(
    PaidDateMonth, PrescriberLocation, NumberOfPaidItems,
    HB, HSCP, GPCluster, PracticeListSize, DispenserLocation,
    age_0_19, age_20_29, age_30_65, age_65_plus, GPPracticeName, AddressLine1, AddressLine2, AddressLine3, Postcode, PracticeType, PrescriberType, Year, MonthNum
  ) 
}

if (model_type %in% c("Charlie", "Delta")) {
  test_Df <- test_Df %>%
    select(PaidDateMonth, PrescriberLocation, PrescriberLocationType,
           DispenserLocation, DispenserLocationType, NumberOfPaidItems,
           HB, HSCP, DataZone, GPCluster, PracticeListSize, age_0_19, age_20_29, age_30_65, age_65_plus, PrescriberType, Year, MonthNum)
}

if (model_type != "Beta") {
  # --- Generate predictions and residuals ---
  test_Df[, Predicted := predict(rf_model, test_Df)$predictions]
  test_Df[, Residual := NumberOfPaidItems - Predicted]
  test_Df[, AbsResidual := abs(Residual)]
  
}


if (model_type == "Beta") {
  
  test_Df[, Predicted :=
            expm1(predict(rf_model, test_Df)$predictions)
  ]
  test_Df[, Residual := NumberOfPaidItems - Predicted]
  test_Df[, AbsResidual := abs(Residual)]
}


# --- Identify outliers (top 5% by absolute residual) ---
threshold <- quantile(test_Df$AbsResidual, 0.95)
test_Df[, Outlier := AbsResidual > threshold]


# --- Optional: Summary outputs ---
cat("Outlier threshold:", round(threshold, 2), "\n")
cat("Number of outliers:", sum(df$Outlier), "of", nrow(df), "records\n")

# View top 10 most extreme outliers
head(test_Df[order(-AbsResidual)], 10)

if (save_output == "Yes") {
  
  test_Df <- test_Df %>% 
    mutate(Importance = importance_type, Number_of_trees = tree_number)
  
  HB_Lookup <- get_resource(res_id = "652ff726-e676-4a20-abda-435b98dd7bdc")
  
  HB_Lookup <- HB_Lookup |>
    select(-Country,-HBDateEnacted)|>
    filter(is.na(HBDateArchived))|>
    select(-HBDateArchived) %>% 
    mutate(GeoType = "Health Board") 
  
  file_name <- glue(
    "Databricks/result_{importance_type}_{tree_number}_{model_type}_{Sys.Date()}.parquet"
  )
  
  test_final <- left_join(HB_Lookup, test_Df, by = 'HB')
  
  test_final <- test_final %>%
    select(-GeoType)
  
  write_parquet(test_final, file_name)
  
}


if (merge_outputs == "Yes") {
  
  #### YOU MUST MOVE ALL THE FILES YOURSELF INTO THE COMBINED FOLDER SO THIS WORKS
  # ---- paths ----
  input_dir  <- "Databricks/Combine/"
  output_file <- file.path(input_dir, "results_all_combined.parquet")
  output_file_final <- file.path(input_dir, "results_all_combined_cleaned.parquet")
  
  
  # ---- list parquet files ----
  files <- list.files(
    path = input_dir,
    pattern = "\\.parquet$",
    full.names = TRUE
  )
  
  # ---- read & combine ----
  results_all <- map_dfr(files, read_parquet)
  
  # ---- optional sanity checks ----
  print(nrow(results_all))
  print(names(results_all))
  
  # ---- write combined parquet ----
  write_parquet(results_all, output_file)
  
  message("Combined parquet written to: ", output_file)
}

#### End of Generic Model Output

#### Model Quality Control Pipeline

if (further_analytics == "Yes") {
  
  #### Shows Variable Importance Figures in  Console
  rf_model$variable.importance
  library(plotly)
  
  # Convert to data frame
  var_imp_df <- data.frame(
    Variable = names(rf_model$variable.importance),
    Importance = as.numeric(rf_model$variable.importance)
  )
  
  # Sort decreasing for nicer visualization
  var_imp_df <- var_imp_df[order(var_imp_df$Importance, decreasing = TRUE), ]
  
  # Plotly bar chart
  fig <- plot_ly(
    data = var_imp_df,
    x = ~Importance,
    y = ~reorder(Variable, Importance),
    type = 'bar',
    orientation = 'h',   # horizontal bars
    marker = list(color = 'steelblue')
  ) %>%
    layout(
      title = "Random Forest Variable Importance",
      xaxis = list(title = "Importance"),
      yaxis = list(title = "Variable")
    )
  
  fig
  
  #### This section will grow in size soon.
  
}