# --- Load libraries ---
library(data.table)
library(phsopendata)   # For live PHS data
library(dplyr)
library(lubridate)
library(ranger)        # Much faster alternative to randomForest
library(arrow)
library(glue)


# --- Load main prescribing dataset ---
df <- read_parquet("Databricks/presdisp.parquet")
# Convert PrescriberLocation to numeric
df$PrescriberLocation <- as.numeric(df$PrescriberLocation)


# --- Load GP practice list and join ---
gp_list <- get_resource(res_id = "30b06220-17ad-44e8-b6c5-658d41ec1ea5") %>%
  select(PracticeCode, HB, HSCP, DataZone, GPCluster, PracticeListSize) %>%
  distinct() %>%
  rename(PrescriberLocation = PracticeCode) 

### This information will only consider open practices 
gp_further_info <- get_resource(res_id = "ac5a7a66-7bf9-4ea0-b076-a0de9fb71ad6")

gp_further_info <- gp_further_info %>%
  filter(Sex == "All") %>%
  select(-ends_with("QF")) %>%
  rename_with(~ gsub("Ages", "", .x)) %>%
  rename_with(~ gsub("plus", "85to99", .x)) %>%
  rename_with(~ gsub("to", "-", .x))

# ---- FIXED SAFE COLUMN GETTER ----
get_col <- function(x) {
  if (x %in% colnames(gp_further_info)) {
    gp_further_info[[x]]
  } else {
    rep(0, nrow(gp_further_info))
  }
}

# ---- EXCLUSIVE AGE BANDS ----
gp_further_info <- gp_further_info %>%
  mutate(
    age_0_19 =
      get_col("00-04") +
      get_col("05-09") +
      get_col("10-14") +
      get_col("15-19"),
    
    age_20_29 =
      get_col("20-24") +
      get_col("25-29"),
    
    age_30_65 =
      get_col("30-34") +
      get_col("35-39") +
      get_col("40-44") +
      get_col("45-49") +
      get_col("50-54") +
      get_col("55-59") +
      get_col("60-64"),
    
    age_65_plus =
      get_col("65-69") +
      get_col("70-74") +
      get_col("75-79") +
      get_col("80-84") +
      get_col("8585-99")
  )

gp_further_info <- gp_further_info %>% 
  select(PracticeCode, age_0_19, age_20_29, age_30_65, age_65_plus) %>% 
  rename(PrescriberLocation = PracticeCode) %>% 
  ungroup()


gp_list <- left_join(gp_list, gp_further_info, by = "PrescriberLocation" )


df <- df %>%
  filter(PrescriberLocationType == "GP PRACTICE") %>% 
  filter(DispenserLocationType == "COMMUNITY PHARMACY")

# Join to GP metadata
df <- left_join(gp_list, df, by = "PrescriberLocation")

df <- df %>%
  select(PaidDateMonth, PrescriberLocation, PrescriberLocationType,
         DispenserLocation, DispenserLocationType, NumberOfPaidItems,
         HB, HSCP, DataZone, GPCluster, PracticeListSize, age_0_19, age_20_29, age_30_65, age_65_plus, PrescriberType)




df <- df %>%
  mutate(
    PaidDateMonth = lubridate::ym(PaidDateMonth),
    MonthNum = lubridate::month(PaidDateMonth),
    Year = lubridate::year(PaidDateMonth)
  )

df <- df %>% filter(!is.na(PrescriberType))

df <- df %>%  filter(Year != 2025)


factor_vars <- c("HB", "HSCP", "GPCluster", "PrescriberType")


# --- Convert to data.table for speed ---
setDT(df)

df[, (factor_vars) := lapply(.SD, as.factor), .SDcols = factor_vars]



# --- Train fast random forest model (ranger) ---
set.seed(123)

# "none"	No variable importance computed (fastest).
# "impurity"	Gini impurity decrease (classification) or variance decrease (regression). Fast, but biased toward variables with many categories.
# "impurity_corrected"	Bias-corrected impurity importance. Slower but more reliable than plain impurity.
# "permutation"	Permutation importance. Measures drop in prediction accuracy when a variable is permuted. Reliable but slower.

importance_type <- "impurity_corrected"

tree_number <- 20

rf_model <- ranger(
  NumberOfPaidItems ~ MonthNum + PaidDateMonth + PracticeListSize + age_0_19 + age_20_29 + age_30_65 + age_65_plus + GPCluster + HSCP + DataZone + HB  + PrescriberType,
  data = df,
  num.trees = tree_number,                     # fewer trees for speed; increase if needed
  importance = importance_type,
  num.threads = 2
  # num.threads = parallel::detectCores() - 1
)

test_Df <- get_resource(res_id = "a203c8fc-c19d-451c-b637-781ea7c2066c")

# Convert PrescriberLocation to numeric
test_Df$PrescriberLocation <- as.numeric(test_Df$PrescriberLocation)


# Keep only GP practices
test_Df <- test_Df %>%
  filter(PrescriberLocationType == "GP PRACTICE")%>% 
  filter(DispenserLocationType == "COMMUNITY PHARMACY") 

# Join to GP metadata
test_Df <- left_join(gp_list, test_Df, by = "PrescriberLocation")


# --- Select and clean variables ---
test_Df <- test_Df %>%
  select(PaidDateMonth, PrescriberLocation, PrescriberLocationType,
         DispenserLocation, DispenserLocationType, NumberOfPaidItems,
         HB, HSCP, DataZone, GPCluster, PracticeListSize, age_0_19, age_20_29, age_30_65, age_65_plus, PrescriberType)



# --- Convert dates and extract time features ---
test_Df <- test_Df %>%
  mutate(
    PaidDateMonth = lubridate::ym(PaidDateMonth),
    MonthNum = lubridate::month(PaidDateMonth),
    Year = lubridate::year(PaidDateMonth)
  )

test_Df <- test_Df %>% filter(!is.na(PrescriberType))

# --- Convert to data.table for speed ---
setDT(test_Df)

test_Df[, (factor_vars) := lapply(.SD, as.factor), .SDcols = factor_vars]

# --- Generate predictions and residuals ---
test_Df[, Predicted := predict(rf_model, test_Df)$predictions]
test_Df[, Residual := NumberOfPaidItems - Predicted]
test_Df[, AbsResidual := abs(Residual)]


# --- Identify outliers (top 5% by absolute residual) ---
threshold <- quantile(test_Df$AbsResidual, 0.95)
test_Df[, Outlier := AbsResidual > threshold]


# --- Optional: Summary outputs ---
cat("Outlier threshold:", round(threshold, 2), "\n")
cat("Number of outliers:", sum(df$Outlier), "of", nrow(df), "records\n")

# View top 10 most extreme outliers
head(test_Df[order(-AbsResidual)], 10)

test_Df <- test_Df %>% 
  mutate(Importance = importance_type, Number_of_trees = tree_number)

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

file_name <- glue("Databricks/Combine/result_{importance_type}_{tree_number}.parquet")

write_parquet(test_Df, file_name)

# 
# 
# library(arrow)
# library(dplyr)
# library(purrr)
# 
# # ---- paths ----
# input_dir  <- "Databricks/Combine/"
# output_file <- file.path(input_dir, "results_all_combined.parquet")
# output_file_final <- file.path(input_dir, "results_all_combined_cleaned.parquet")
# 
# 
# # ---- list parquet files ----
# files <- list.files(
#   path = input_dir,
#   pattern = "\\.parquet$",
#   full.names = TRUE
# )
# 
# # ---- read & combine ----
# results_all <- map_dfr(files, read_parquet)
# 
# # ---- optional sanity checks ----
# print(nrow(results_all))
# print(names(results_all))
# 
# # ---- write combined parquet ----
# write_parquet(results_all, output_file)
# 
# message("Combined parquet written to: ", output_file)
# 
# 
# library(arrow)
# test <- read_parquet(output_file)
# 
# test_final <- left_join(HB_Lookup, test, by = 'HB')
# 
# test_final <- test_final %>%
#   select(-GeoType)
# 
# write_parquet(test_final, output_file_final)
# 
