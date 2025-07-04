#### Calling in data from PHS website
WeeklyAE <- get_resource(res_id = "a5f7ca94-c810-41b5-a7c9-25c18d43e5a4")
AE_Sites <- get_resource(res_id = "1a4e3f48-3d9b-4769-80e9-3ef6d27852fe")


#### Converting to Date Format
WeeklyAE$WeekEndingDate <- as.Date(
  as.character(WeeklyAE$WeekEndingDate),
  format = "%Y%m%d"
)

#### Removing useless columns 

WeeklyAE <- WeeklyAE %>% 
  select(-Country, -DepartmentType)

#### Creating lookup for A&E data to perform join

HB_Lookup_AE <- HB_Lookup %>% 
  select(-GeoType) %>% 
  rename(HBT = HB)

#### Cleaning A&E Sites lookup File

AE_Sites <- AE_Sites %>% 
  select(TreatmentLocationName, TreatmentLocationCode, CurrentDepartmentType)

#### Joining HBT code with HB Name to dataset
WeeklyAE <- full_join(WeeklyAE, HB_Lookup_AE, by = "HBT") %>%
  select(-HBT) %>% 
  rename(TreatmentLocationCode = TreatmentLocation)

#### Joining HBT code with HB Name to dataset
WeeklyAE <- left_join(WeeklyAE, AE_Sites, by = "TreatmentLocationCode") 

WeeklyAE <- WeeklyAE %>% 
  filter(CurrentDepartmentType == "Type 1") ### Removes Type 3 minor injury rows (around 20/30 exist in 2015 for two glasgow locations)


