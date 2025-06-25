diagnostics_waiting_times <- get_resource(res_id = "10dfe6f3-32de-4039-84c2-7e7794a06b31") ### Loads in data from open data scotland

HB_Pop_Estimates <- get_resource(res_id = "27a72cc8-d6d8-430c-8b4f-3109a9ceadb1")
HB_Pop_Estimates <- HB_Pop_Estimates %>% 
  select(Year, HB, Sex, AllAges) 

# Check if 2023 data is available
if (2023 %in% HB_Pop_Estimates$Year) {
  
  # Identify missing years
  missing_years <- setdiff(c(2024, 2025), unique(HB_Pop_Estimates$Year))
  
  # If any missing, duplicate 2023 data for those years
  if (length(missing_years) > 0) {
    data_2023 <- HB_Pop_Estimates %>% filter(Year == 2023)
    
    # Create duplicates for each missing year
    data_copies <- lapply(missing_years, function(y) {
      data_2023 %>% mutate(Year = y)
    }) %>% bind_rows()
    
    # Append to the main data frame
    HB_Pop_Estimates <- bind_rows(HB_Pop_Estimates, data_copies)
  }
}

HB_Lookup_Diagnostics <- HB_Lookup %>% 
  select(-GeoType)


  HB_Pop_Estimates <- full_join(HB_Pop_Estimates, HB_Lookup_Diagnostics, by = "HB") %>% 
    filter(!is.na(HBName))
  
  HB_Pop_Diagnostics <- HB_Pop_Estimates %>% 
    filter(Sex == "All")


#### Data Cleaning
diagnostics_waiting_times <- diagnostics_waiting_times %>% 
  select(-NumberOnListQF) %>% 
  rename(HB = HBT)

#### Converting monthending to date format.
diagnostics_waiting_times$MonthEnding <- ymd(diagnostics_waiting_times$MonthEnding)

#### Joining HB code with HB Name to dataset
diagnostics_waiting_times <- full_join(HB_Lookup_Diagnostics, diagnostics_waiting_times, by = "HB") %>%
  filter(HB != "SB0801") %>%  ### Removed as not interested in this board
  select(-HB)



### Imaging Dataset

diagnostics_waiting_times_imaging <- diagnostics_waiting_times %>%
  filter(DiagnosticTestType == "Imaging")

### making changes to data to use 2023 population estimate for rates
diagnostics_waiting_times_imaging_100k_rate <- diagnostics_waiting_times_imaging %>%
mutate(Year = MonthEnding)


diagnostics_waiting_times_imaging_100k_rate$Year <- substr(diagnostics_waiting_times_imaging_100k_rate$Year, 1, 4) # Keeps 1st to 4th number in string which is the year

diagnostics_waiting_times_imaging_100k_rate$Year <- as.numeric(diagnostics_waiting_times_imaging_100k_rate$Year)

diagnostics_waiting_times_imaging_100k_rate <- full_join(diagnostics_waiting_times_imaging_100k_rate,HB_Pop_Diagnostics,by = c("HBName", "Year")) #### Joining allages data onto dataset for rate calculation

#### Calculate rates for imaging
diagnostics_waiting_times_imaging_100k_rate <- diagnostics_waiting_times_imaging_100k_rate %>%
  select(-HB, -Year) %>%
  mutate(Rate = NumberOnList/AllAges) %>%
  mutate(Rate = Rate * 100000) %>%
  select(-AllAges) 



### Endoscopy Dataset
diagnostics_waiting_times_endoscopy <- diagnostics_waiting_times %>%
  filter(DiagnosticTestType == "Endoscopy")

### making changes to data to use 2023 population estimate for rates
diagnostics_waiting_times_endoscopy_per_100k <- diagnostics_waiting_times_endoscopy %>%
  mutate(Year = MonthEnding) 

diagnostics_waiting_times_endoscopy_per_100k$Year <- substr(diagnostics_waiting_times_endoscopy_per_100k$Year, 1, 4)# Keeps 1st to 4th number in string which is the year

diagnostics_waiting_times_endoscopy_per_100k$Year <- as.numeric(diagnostics_waiting_times_endoscopy_per_100k$Year)

diagnostics_waiting_times_endoscopy_per_100k <- full_join(diagnostics_waiting_times_endoscopy_per_100k,HB_Pop_Diagnostics,by = c("HBName", "Year")) #### Joining allages data onto dataset for rate calculation

# Rate calculations
diagnostics_waiting_times_endoscopy_per_100k<- diagnostics_waiting_times_endoscopy_per_100k %>%
  select(-HB, -Year) %>%
  mutate(Rate = NumberOnList/AllAges) %>%
  mutate(Rate = Rate * 100000) %>%
  select(-AllAges)


rm(diagnostics_waiting_times_endoscopy, diagnostics_waiting_times_imaging) # No longer needed

diagnostics_final_dataset_rates <- bind_rows(diagnostics_waiting_times_endoscopy_per_100k,diagnostics_waiting_times_imaging_100k_rate)

diagnostics_final_dataset_rates <- diagnostics_final_dataset_rates %>% 
  filter(!is.na(MonthEnding)) %>% 
  filter(!is.na(NumberOnList)) %>% 
  select(-Sex)

rm(diagnostics_waiting_times, diagnostics_waiting_times_endoscopy_per_100k, diagnostics_waiting_times_imaging_100k_rate)


##### Preparing lists for filters 

diagnostics_waiting_time_filter_list <- diagnostics_final_dataset_rates %>% 
  select(WaitingTime) %>% 
  unique() %>%
  mutate(
    StartDay = as.numeric(str_extract(WaitingTime, "^\\d+"))
  ) %>%
  arrange(StartDay) %>%
  select(WaitingTime) %>% 
  filter(WaitingTime != "Total Number Waiting")

diagnostics_waiting_time_filter_list_total <- diagnostics_waiting_time_filter_list %>% 
  mutate(WaitingTime = "Total Number Waiting") %>% 
  unique()

diagnostics_waiting_time_filter_list <- bind_rows(diagnostics_waiting_time_filter_list_total, diagnostics_waiting_time_filter_list)

diagnostics_test_type_list <- diagnostics_final_dataset_rates %>% 
  select(DiagnosticTestType) %>% 
  unique()
