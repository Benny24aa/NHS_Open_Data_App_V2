library(phsopendata)
library(dplyr)

# Download all resources for the dataset
presdisp <- get_dataset("prescribed-dispensed", include_context = TRUE)

### Removes last three months data to avoid duplicates
presdisp <- presdisp %>% 
  filter(ResID != "31576bf0-fc05-49ff-a99a-2c253a0c3342") %>% 
  select(-ResName, -ResID, -ResCreatedDate, -ResModifiedDate)

library(arrow)

write_parquet(presdisp, "Databricks/presdisp.parquet")

rm(presdisp)

t <- read_parquet("Databricks/presdisp.parquet")