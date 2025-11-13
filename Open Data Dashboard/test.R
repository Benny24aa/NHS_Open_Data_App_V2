# --- Load libraries ---
library(data.table)
library(phsopendata)   # For live PHS data
library(dplyr)
library(lubridate)
library(ranger)        # Much faster alternative to randomForest


# --- Load main prescribing dataset ---
df <- get_resource(res_id = "a203c8fc-c19d-451c-b637-781ea7c2066c")

# Convert PrescriberLocation to numeric
df$PrescriberLocation <- as.numeric(df$PrescriberLocation)


# --- Load GP practice list and join ---
gp_list <- get_resource(res_id = "30b06220-17ad-44e8-b6c5-658d41ec1ea5") %>%
  select(PracticeCode, HB, HSCP, DataZone, GPCluster, PracticeListSize) %>%
  distinct() %>%
  rename(PrescriberLocation = PracticeCode) 

# Keep only GP practices and Glasgow and Clyde Locations
df <- df %>%
  filter(PrescriberLocationType == "GP PRACTICE") %>% 
  filter(DispenserLocationType == "COMMUNITY PHARMACY")
# Join to GP metadata
df <- left_join(gp_list, df, by = "PrescriberLocation")


# --- Select and clean variables ---
df <- df %>%
  select(PaidDateMonth, PrescriberLocation, PrescriberLocationType,
         DispenserLocation, DispenserLocationType, NumberOfPaidItems,
         HB, HSCP, DataZone, GPCluster, PracticeListSize) %>% 
  filter(HB == "S08000031")



# --- Convert dates and extract time features ---
df <- df %>%
  mutate(
    PaidDateMonth = lubridate::ym(PaidDateMonth),
    MonthNum = lubridate::month(PaidDateMonth),
    Year = lubridate::year(PaidDateMonth)
  )


# --- Convert to data.table for speed ---
setDT(df)




# --- Train fast random forest model (ranger) ---
set.seed(123)

rf_model <- ranger(
  NumberOfPaidItems ~ MonthNum + GPCluster + HSCP + DataZone,
  data = df,
  num.trees = 200,                     # fewer trees for speed; increase if needed
  importance = "impurity",
  num.threads = parallel::detectCores() - 1
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
         HB, HSCP, DataZone, GPCluster, PracticeListSize)%>% 
  filter(HB == "S08000031")



# --- Convert dates and extract time features ---
test_Df <- test_Df %>%
  mutate(
    PaidDateMonth = lubridate::ym(PaidDateMonth),
    MonthNum = lubridate::month(PaidDateMonth),
    Year = lubridate::year(PaidDateMonth)
  )


# --- Convert to data.table for speed ---
setDT(test_Df)


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