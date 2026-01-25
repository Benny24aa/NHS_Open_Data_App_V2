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