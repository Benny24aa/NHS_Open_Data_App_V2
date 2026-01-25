#### Script Setup ###


# --- Load libraries ---
library(data.table)
library(phsopendata)   # For live PHS data
library(dplyr)
library(lubridate)
library(ranger)        # Much faster alternative to randomForest
library(arrow)
library(glue)


###### Define the type of model you wish to run, this could be Alpha, Beta, Charlie, or Delta.

model_type <- "Alpha"

# "none"	No variable importance computed (fastest).
# "impurity"	Gini impurity decrease (classification) or variance decrease (regression). Fast, but biased toward variables with many categories.
# "impurity_corrected"	Bias-corrected impurity importance. Slower but more reliable than plain impurity.
# "permutation"	Permutation importance. Measures drop in prediction accuracy when a variable is permuted. Reliable but slower.

importance_type <- "impurity_corrected"

# We look at 5, 10, 20, 50 and 100 for the number of trees

tree_number <- 100

####### Preparing Data for Random Forest Model of Choice

# --- Load main prescribing dataset ---
df <- read_parquet("Databricks/presdisp.parquet")
# Convert PrescriberLocation to numeric
df$PrescriberLocation <- as.numeric(df$PrescriberLocation)

# --- Load GP practice list and join ---
gp_list <- get_resource(res_id = "30b06220-17ad-44e8-b6c5-658d41ec1ea5") %>%
  select(PracticeCode, HB, HSCP, DataZone, GPCluster, PracticeListSize) %>%
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