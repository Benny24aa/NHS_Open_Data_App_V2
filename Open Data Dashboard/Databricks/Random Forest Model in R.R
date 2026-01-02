library(data.table)
library(phsopendata)
library(dplyr)
library(lubridate)
library(ranger)
library(arrow)
library(glue)

# --- Load main prescribing dataset ---
df <- read_parquet("Databricks/presdisp.parquet")
df$PrescriberLocation <- as.numeric(df$PrescriberLocation)

# --- Load GP practice list ---
gp_list <- get_resource(res_id = "30b06220-17ad-44e8-b6c5-658d41ec1ea5") %>%
  select(PracticeCode, HB, HSCP, DataZone, GPCluster, PracticeListSize, GPPracticeName, AddressLine1, AddressLine2, AddressLine3, Postcode, PracticeType) %>%
  distinct() %>%
  rename(PrescriberLocation = PracticeCode)

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
  ) %>%
  left_join(gp_list, by = "PrescriberLocation") %>%
  select(
    PaidDateMonth, PrescriberLocation, DispenserLocation, NumberOfPaidItems,
    HB, HSCP, GPCluster, PracticeListSize,
    age_0_19, age_20_29, age_30_65, age_65_plus, GPPracticeName, AddressLine1, AddressLine2, AddressLine3, Postcode, PracticeType, PrescriberType
  ) %>%
  mutate(
    PaidDateMonth = ym(PaidDateMonth),
    MonthNum = month(PaidDateMonth),
    Year = year(PaidDateMonth),
    log_items = log1p(NumberOfPaidItems)
  )

setDT(df)

df <- df %>% filter(!is.na(HB))


# ---------------------------------------------------
# --- TRAIN RANDOM FOREST (REGULARISED, LOG SCALE) ---
# ---------------------------------------------------

set.seed(123)

tree_number <- 5
importance_type <- "permutation"

df[, c("GPCluster", "HSCP", "HB") := lapply(.SD, as.factor), .SDcols = c("GPCluster", "HSCP", "HB")]

df$PrescriberLocation <- factor(df$PrescriberLocation)
df$DispenserLocation  <- factor(df$DispenserLocation)
df$MonthNum  <- factor(df$MonthNum)
df$GPPracticeName <- factor(df$GPPracticeName)
df$AddressLine1 <- factor(df$AddressLine1)
df$AddressLine2 <- factor(df$AddressLine2)
df$AddressLine3 <- factor(df$AddressLine3)
df$Postcode <- factor(df$Postcode)
df$PracticeType <- factor(df$PracticeType)
df$PrescriberType <- factor(df$PrescriberType)


# GPCluster + HSCP + HB + 

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




# ---------------------------------------------------
# --- LOAD TEST DATA ---
# ---------------------------------------------------

test_Df <- get_resource(res_id = "a203c8fc-c19d-451c-b637-781ea7c2066c")
test_Df$PrescriberLocation <- as.numeric(test_Df$PrescriberLocation)



test_Df <- test_Df %>%
  filter(
    PrescriberLocationType == "GP PRACTICE",
    DispenserLocationType == "COMMUNITY PHARMACY"
  ) %>%
  left_join(gp_list, by = "PrescriberLocation") %>%
  select(
    PaidDateMonth, PrescriberLocation, NumberOfPaidItems,
    HB, HSCP, GPCluster, PracticeListSize, DispenserLocation,
    age_0_19, age_20_29, age_30_65, age_65_plus, GPPracticeName, AddressLine1, AddressLine2, AddressLine3, Postcode, PracticeType, PrescriberType
  ) %>%
  mutate(
    PaidDateMonth = ym(PaidDateMonth),
    MonthNum = month(PaidDateMonth),
    Year = year(PaidDateMonth)
  )

setDT(test_Df)

# ---------------------------------------------------
# --- PREDICTIONS (BACK-TRANSFORMED) ---
# ---------------------------------------------------

test_Df$PrescriberLocation <- factor(test_Df$PrescriberLocation)
test_Df$DispenserLocation  <- factor(test_Df$DispenserLocation)
test_Df$MonthNum  <- factor(test_Df$MonthNum)
test_Df$GPPracticeName <- factor(test_Df$GPPracticeName)
test_Df$AddressLine1 <- factor(test_Df$AddressLine1)
test_Df$AddressLine2 <- factor(test_Df$AddressLine2)
test_Df$AddressLine3 <- factor(test_Df$AddressLine3)
test_Df$Postcode <- factor(test_Df$Postcode)
test_Df$PracticeType <- factor(test_Df$PracticeType)
test_Df$PrescriberType <- factor(test_Df$PrescriberType)


test_Df[, c("GPCluster", "HSCP", "HB") := lapply(.SD, as.factor), .SDcols = c("GPCluster", "HSCP", "HB")]


test_Df[, Predicted :=
          expm1(predict(rf_model, test_Df)$predictions)
]

test_Df[, Residual := NumberOfPaidItems - Predicted]
test_Df[, AbsResidual := abs(Residual)]

# ---------------------------------------------------
# --- OUTLIER FLAG (TOP 5%) ---
# ---------------------------------------------------

threshold <- quantile(test_Df$AbsResidual, 0.95, na.rm = TRUE)
test_Df[, Outlier := AbsResidual > threshold]

# ---------------------------------------------------
# --- METADATA + SAVE ---
# ---------------------------------------------------

test_Df[, `:=`(
  Importance = importance_type,
  Number_of_trees = tree_number
)]

test_Df <- test_Df %>% filter(!is.na(HB))

file_name <- glue("Databricks/result_log_rf_{importance_type}_{tree_number}.parquet")
write_parquet(test_Df, file_name)

cat("Outlier threshold:", round(threshold, 2), "\n")
cat("Number of outliers:", sum(test_Df$Outlier), "of", nrow(test_Df), "\n")

dup_counts <- df %>%
  count(PaidDateMonth, PrescriberLocation, DispenserLocation, PrescriberType, name = "n")

dup_counts <- dup_counts%>%
  filter(n > 1)


df_test_threshold <- test_Df %>% 
  dplyr::mutate(
    NumberOfPaidItems = as.numeric(NumberOfPaidItems),
    Predicted = as.numeric(Predicted),
    Outlier = as.logical(Outlier),
    PrescriberLocation = as.numeric(PrescriberLocation),
    DispenserLocation = as.numeric(DispenserLocation)
  ) %>% 
  dplyr::mutate(
    Predicted = round(Predicted, 0),
    Residual = NumberOfPaidItems - Predicted,
    FitDirection = dplyr::case_when(
      Residual > 0  ~ "Underfitting",
      Residual < 0  ~ "Overfitting",
      Residual == 0 ~ "Perfect fit"
    ),
    AbsResidual = abs(Residual),
    TenPercentValue = NumberOfPaidItems/100 * 10,
    WithinTenPercent = TenPercentValue > AbsResidual,
    FinalFit = dplyr::if_else(
      WithinTenPercent,
      "Perfect Fit",
      FitDirection
    ))


# 
# 
# library(arrow)
# library(dplyr)
# library(purrr)
# 
# # ---- paths ----
# input_dir  <- "Databricks/Combine/"
# output_file <- file.path(input_dir, "results_all_combined.parquet")
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
# input_dir  <- "Databricks/Combine/"
# output_file <- file.path(input_dir, "results_all_combined.parquet")
# 
# library(arrow)
# test <- read_parquet(output_file)
# 
# test_final <- left_join(HB_Lookup, test, by = 'HB')
# 
# test_final <- test_final %>% 
#   select(-GeoType)
# 
# write_parquet(test_final, output_file)
