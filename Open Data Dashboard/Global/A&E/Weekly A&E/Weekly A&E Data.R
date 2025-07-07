#### Load data from PHS Open Data
WeeklyAE <- get_resource(res_id = "a5f7ca94-c810-41b5-a7c9-25c18d43e5a4")
AE_Sites <- get_resource(res_id = "1a4e3f48-3d9b-4769-80e9-3ef6d27852fe")

#### Prepare lookup table 
HB_Lookup_AE <- HB_Lookup %>%
  select(-GeoType) %>%
  rename(HBT = HB)

#### Process A&E Sites
AE_Sites <- AE_Sites %>%
  select(TreatmentLocationCode, TreatmentLocationName, CurrentDepartmentType)

#### Clean and join WeeklyAE data
WeeklyAE <- WeeklyAE %>%
  mutate(
    WeekEndingDate = ymd(WeekEndingDate)
  ) %>%
  select(-Country, -DepartmentType) %>%
  full_join(HB_Lookup_AE, by = "HBT") %>%
  rename(TreatmentLocationCode = TreatmentLocation) %>%
  left_join(AE_Sites, by = "TreatmentLocationCode") %>%
  filter(CurrentDepartmentType == "Type 1") %>% ### Removing 2 historical Glasgow locations from the dataset as 20/30 rows of data in 2015 were classed as Type 3 (Minor Surgery) based on the reference files
  select(-c(CurrentDepartmentType, TreatmentLocationCode))

Attendance_Category_AE_List <- WeeklyAE %>% 
  select(AttendanceCategory) %>% 
  unique()

HB_Hospital_List <- WeeklyAE %>% 
  select(HBName, TreatmentLocationName) %>% 
  unique()


WeeklyAE_Healthboard <- WeeklyAE %>% 
  select(WeekEndingDate, AttendanceCategory, HBName, NumberOfAttendancesEpisode, NumberOver4HoursEpisode, NumberOver8HoursEpisode, NumberOver12HoursEpisode, NumberWithin4HoursEpisode)

WeeklyAE_Healthboard <- WeeklyAE_Healthboard %>%
  group_by(HBName, WeekEndingDate, AttendanceCategory) %>%
  summarise(
    TotalAttendances = sum(NumberOfAttendancesEpisode, na.rm = TRUE),
    TotalOver4Hours = sum(NumberOver4HoursEpisode, na.rm = TRUE),
    TotalOver8Hours = sum(NumberOver8HoursEpisode, na.rm = TRUE),
    TotalOver12Hours = sum(NumberOver12HoursEpisode, na.rm = TRUE),
    TotalWithin4Hours = sum(NumberWithin4HoursEpisode, na.rm = TRUE),
    .groups = "drop"
  )

latest_two_weeks <- WeeklyAE_Healthboard %>%
  distinct(WeekEndingDate) %>%
  arrange(desc(WeekEndingDate)) %>%
  slice(1:2) %>%
  pull(WeekEndingDate)

WeeklyAE_Healthboard <- WeeklyAE_Healthboard %>%
  filter(WeekEndingDate %in% latest_two_weeks)