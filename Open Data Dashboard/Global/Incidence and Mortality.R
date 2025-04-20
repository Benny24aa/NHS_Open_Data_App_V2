Cancer_Data_Mortality_HB <- get_resource(res_id = "57f0983f-864e-4dbd-b3dc-ea8f16de83a4")
Cancer_Data_Incidence_HB <- get_resource(res_id = "3aef16b7-8af6-4ce0-a90b-8a29d6870014")

Cancer_Data_Mortality_HB <- full_join(Cancer_Data_Mortality_HB, HB_Lookup, by = "HB") %>% 
  mutate(DataType = "Mortality") %>% 
  rename(GeoCode = HB, GeoName = HBName)


Cancer_Data_Mortality_HB<- Cancer_Data_Mortality_HB  %>%
  select(GeoCode, CancerSiteICD10Code, CancerSite, Sex, Year, DeathsAllAges, CrudeRate, EASR, WASR, StandardisedMortalityRatio, GeoName, GeoType, DataType) %>% 
  rename(AllAges = DeathsAllAges, StandardisedRatio = StandardisedMortalityRatio)

Cancer_Mortality_HB_Scotland <- Cancer_Data_Mortality_HB %>% 
  mutate(GeoName = "All Scotland Data")

Cancer_Data_Mortality_Cleaned <- bind_rows(Cancer_Data_Mortality_HB, Cancer_Mortality_HB_Scotland)

Cancer_Data_Incidence_HB <- full_join(Cancer_Data_Incidence_HB, HB_Lookup, by = "HB") %>% 
  mutate(DataType = "Incidence") %>% 
  rename(GeoCode = HB, GeoName = HBName, AllAges = IncidencesAllAges, StandardisedRatio = StandardisedIncidenceRatio)

Cancer_Incidence_HB_Scotland <- Cancer_Data_Incidence_HB %>% 
  mutate(GeoName = "All Scotland Data")

Cancer_Data_Incidence_HB <- bind_rows(Cancer_Data_Incidence_HB, Cancer_Incidence_HB_Scotland)


Cancer_Data_Incidence_HB <- Cancer_Data_Incidence_HB %>% 
  select(GeoCode, CancerSiteICD10Code, CancerSite, Sex, Year, AllAges, CrudeRate, EASR, WASR, StandardisedRatio, GeoName, GeoType, DataType) 


Cancer_Full_Data <- bind_rows(Cancer_Data_Incidence_HB, Cancer_Data_Mortality_Cleaned) %>% 
  rename(HBName = GeoName) %>% 
  mutate(Sex = gsub("Females", "Female", Sex)) %>% 
  filter(CancerSite != "All cancer types incl NMSC") %>% 
  filter(CancerSite != "All brain and CNS tumours (malignant and non-malignant)")

Cancer_Full_Data$Year <- as.Date(as.character(Cancer_Full_Data$Year), format = "%Y")

Cancer_Data_Type <- Cancer_Full_Data %>% 
  select(DataType) %>% 
  distinct()

Graph_Types <- c("AllAges", "CrudeRate", "EASR", "WASR", "StandardisedRatio")
GraphTypeOptions <- data.frame(Graph_Types)

cancer_types <- Cancer_Full_Data %>% 
  select(CancerSite) %>% 
  unique() %>% 
  arrange(CancerSite)

cancer_types_all_filtered <- cancer_types %>% 
  filter(grepl('All', CancerSite))

cancer_types <- cancer_types %>% 
  filter(!grepl("All", CancerSite))

cancer_types <- bind_rows(cancer_types_all_filtered, cancer_types)