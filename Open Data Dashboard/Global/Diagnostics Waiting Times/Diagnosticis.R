diagnostics_waiting_times <- get_resource(res_id = "10dfe6f3-32de-4039-84c2-7e7794a06b31") ### Loads in data from open data scotland

HB_Pop_Estimates <- get_resource(res_id = "27a72cc8-d6d8-430c-8b4f-3109a9ceadb1")
HB_Pop_Estimates <- HB_Pop_Estimates %>% 
  select(Year, HB, Sex, AllAges) 

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
  filter(DiagnosticTestType == "Imaging")%>%
  select(-DiagnosticTestType)

### making changes to data to use 2023 population estimate for rates
diagnostics_waiting_times_imaging_100k_rate <- diagnostics_waiting_times_imaging %>%
  filter(MonthEnding > '2020-01-01') %>%
mutate(Year = MonthEnding)


diagnostics_waiting_times_imaging_100k_rate$Year <- substr(diagnostics_waiting_times_imaging_100k_rate$Year, 1, 4) # Keeps 1st to 4th number in string which is the year

diagnostics_waiting_times_imaging_100k_rate$Year <- as.numeric(diagnostics_waiting_times_imaging_100k_rate$Year)

diagnostics_waiting_times_imaging_100k_rate <- full_join(diagnostics_waiting_times_imaging_100k_rate,HB_Pop_Diagnostics,by = c("HBName", "Year")) #### Joining allages data onto dataset for rate calculation

#### Calculate rates for imaging
diagnostics_waiting_times_imaging_100k_rate <- diagnostics_waiting_times_imaging_100k_rate %>%
  select(-HB, -Year) %>%
  mutate(Rate = NumberOnList/AllAges) %>%
  mutate(Rate = Rate * 100000) %>%
  select(-AllAges) %>% 
  filter(!is.na(Rate))


### Endoscopy Dataset
diagnostics_waiting_times_endoscopy <- diagnostics_waiting_times %>%
  filter(DiagnosticTestType == "Endoscopy") %>%
  select(-DiagnosticTestType)

### making changes to data to use 2023 population estimate for rates
diagnostics_waiting_times_endoscopy_per_100k <- diagnostics_waiting_times_endoscopy %>%
  filter(MonthEnding > '2020-01-01') %>%
  mutate(Year = MonthEnding) 

diagnostics_waiting_times_endoscopy_per_100k$Year <- substr(diagnostics_waiting_times_endoscopy_per_100k$Year, 1, 4)# Keeps 1st to 4th number in string which is the year

diagnostics_waiting_times_endoscopy_per_100k$Year <- as.numeric(diagnostics_waiting_times_endoscopy_per_100k$Year)

diagnostics_waiting_times_endoscopy_per_100k <- full_join(diagnostics_waiting_times_endoscopy_per_100k,HB_Pop_Diagnostics,by = c("HBName", "Year")) #### Joining allages data onto dataset for rate calculation

# Rate calculations
diagnostics_waiting_times_endoscopy_per_100k<- diagnostics_waiting_times_endoscopy_per_100k %>%
  select(-HB, -Year) %>%
  mutate(Rate = NumberOnList/AllAges) %>%
  mutate(Rate = Rate * 100000) %>%
  select(-AllAges)%>% 
  filter(!is.na(Rate))

# Scotland data added and filter for total admissions from day 0
diagnostics_all_total_scotland <- diagnostics_waiting_times %>%
  filter(WaitingTime == "0-7 days") %>%
  select(-HBName, -DiagnosticTestType, -DiagnosticTestDescription, -WaitingTime) %>%
  filter(!is.na(NumberOnList)) %>%
  group_by(MonthEnding) %>%
  summarise(Total_On_Waiting_List = sum(NumberOnList), .groups = 'drop')


rm(diagnostics_waiting_times_endoscopy, diagnostics_waiting_times_imaging) # No longer needed