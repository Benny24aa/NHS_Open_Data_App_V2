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

latest_two_weeks <- WeeklyAE_Healthboard %>%
  distinct(WeekEndingDate) %>%
  arrange(desc(WeekEndingDate)) %>%
  slice(1:2) %>%
  pull(WeekEndingDate)


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

MonthlyAEDemographics <- get_resource(res_id = "6abbf8e4-e4e0-4a56-a7b9-f7c7b4171ff3") %>% 
  select(-SexQF, -DeprivationQF, -AgeQF, -Country) %>% 
  filter(!is.na(Deprivation)) %>% 
  full_join(HB_Lookup_AE, by = "HBT")%>%
  mutate(
    Month = ym(Month)
  ) %>% 
  select(-HBT) %>% 
  filter(!is.na(Age))

AE_Department_Type_Options <- MonthlyAEDemographics %>% 
  select(DepartmentType) %>% 
  unique()


Deprivation_Summary_AE <- MonthlyAEDemographics %>%
  group_by(Month, DepartmentType, HBName, Deprivation) %>%
  summarize(NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(
    names_from = Deprivation,
    values_from = NumberOfAttendances,
    names_prefix = "Deprivation"
  )


Age_Summary_AE <- MonthlyAEDemographics %>%
  group_by(Month, DepartmentType, HBName, Age) %>%
  summarize(NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(
    names_from = Age,
    values_from = NumberOfAttendances
  )

cols_to_rename <- setdiff(names(Age_Summary_AE), c("Month", "DepartmentType", "HBName"))


names(Age_Summary_AE)[names(Age_Summary_AE) %in% cols_to_rename] <- 
  gsub("[- ]", "_", cols_to_rename)

Sex_Summary_AE <- MonthlyAEDemographics %>%
  group_by(Month, DepartmentType, HBName, Sex) %>%
  summarize(NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(
    names_from = Sex,
    values_from = NumberOfAttendances
  )

Monthly_AE_Demographic_Data <- Deprivation_Summary_AE %>%
  full_join(Age_Summary_AE, by = c("Month", "DepartmentType", "HBName")) %>%
  full_join(Sex_Summary_AE, by = c("Month", "DepartmentType", "HBName"))

latest_two_months_ae_demo <- Monthly_AE_Demographic_Data %>%
  distinct(Month) %>%
  arrange(desc(Month)) %>%
  slice(1:2) %>%
  pull(Month)


rm(Age_Summary_AE, Deprivation_Summary_AE, Sex_Summary_AE)

Referral_Source_AE <- get_resource(res_id = "235407ca-1676-472e-9e4d-6e7230934a95") %>% 
  select(-Country, -AgeQF, -ReferralQF) %>% 
  mutate(
    Age = replace_na(Age, "Unknown"),
    Referral = replace_na(Referral, "Unknown"),
    Month = ymd(paste0(Month, "01"))
  ) %>% 
  group_by(Month, HBT, DepartmentType, Age, Referral) %>% 
  summarize(
    NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  full_join(HB_Lookup_AE, by = "HBT") %>% 
  select(-HBT)

Referral_Source_All_Ages_AE <- Referral_Source_AE %>% 
  group_by(Month, HBName, DepartmentType, Referral) %>% 
  summarize(
    NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE),
    .groups = "drop"
  ) %>% 
  mutate(Age = "All")

Referral_Source_AE <- bind_rows(Referral_Source_AE, Referral_Source_All_Ages_AE)

Referral_Source_AE_Graph <- Referral_Source_AE

rm (Referral_Source_All_Ages_AE)

#### Lookups for Referral Source

AE_Referral_Departments <- Referral_Source_AE %>% 
  select(DepartmentType, HBName) %>% 
  unique()

AE_Referral_Age <- Referral_Source_AE %>% 
  select(Age) %>% 
  distinct() %>% 
  arrange(Age) %>% 
  bind_rows(tibble(Age = "All"), .)

latest_two_months_ae_referral <- Referral_Source_AE %>%
  distinct(Month) %>%
  arrange(desc(Month)) %>%
  slice(1:2) %>%
  pull(Month)

Referral_Source_AE <- Referral_Source_AE %>% 
  pivot_wider(
    names_from = Referral,
    values_from = NumberOfAttendances
  )

Referral_Source_AE_Graph <- Referral_Source_AE_Graph %>%
  mutate(Year = year(Month))


######### Discharge Stuff


Discharge_Source_AE <- get_resource(res_id = "c4622324-f59c-4011-a67b-83b59c59ca94") %>% 
  select(-Country, -AgeQF, -DischargeQF) %>% 
  mutate(
    Age = replace_na(Age, "Not Available"),
    Discharge = replace_na(Discharge, "Not Available"),
    Month = ymd(paste0(Month, "01"))
  ) %>% 
  group_by(Month, HBT, DepartmentType, Age, Discharge) %>% 
  summarize(
    NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  full_join(HB_Lookup_AE, by = "HBT") %>% 
  select(-HBT)


Discharge_Source_All_Ages_AE <- Discharge_Source_AE %>% 
  group_by(Month, HBName, DepartmentType, Discharge) %>% 
  summarize(
    NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE),
    .groups = "drop"
  ) %>% 
  mutate(Age = "All")

Discharge_Source_AE <- bind_rows(Discharge_Source_AE, Discharge_Source_All_Ages_AE)

Discharge_Source_AE_Graph <- Discharge_Source_AE

rm (Discharge_Source_All_Ages_AE)

#### Lookups for Referral Source

AE_Discharge_Departments <- Discharge_Source_AE %>% 
  select(DepartmentType, HBName) %>% 
  unique()

AE_Discharge_Age <- Discharge_Source_AE %>% 
  select(Age) %>% 
  distinct() %>% 
  arrange(Age) %>% 
  bind_rows(tibble(Age = "All"), .)

latest_two_months_ae_discharge <- Discharge_Source_AE %>%
  distinct(Month) %>%
  arrange(desc(Month)) %>%
  slice(1:2) %>%
  pull(Month)

Discharge_Source_AE <- Discharge_Source_AE %>% 
  pivot_wider(
    names_from = Discharge,
    values_from = NumberOfAttendances
  )

Discharge_Source_AE_Graph <- Discharge_Source_AE_Graph %>%
  mutate(Year = year(Month))


######### When Data

When_Source_AE <- get_resource(res_id = "022c3b27-6a58-48dc-8038-8f1f93bb0e78") %>% 
 group_by(Month, HBT, DepartmentType, Week, InOut) %>% 
  summarize(
    NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  full_join(HB_Lookup_AE, by = "HBT") %>% 
  select(-HBT) %>% 
  mutate(Month = ymd(paste0(Month, "01")))

When_Source_AE_Graph <- When_Source_AE

AE_When_Departments <- When_Source_AE %>% 
  select(DepartmentType, HBName) %>% 
  unique()

AE_When_InOut <- When_Source_AE %>% 
  select(InOut) %>% 
  distinct()

AE_When_Week <- When_Source_AE %>% 
  select(Week) %>% 
  distinct()

latest_two_months_ae_when <- When_Source_AE %>%
  distinct(Month) %>%
  arrange(desc(Month)) %>%
  slice(1:2) %>%
  pull(Month)

When_Source_AE_Week <- When_Source_AE %>% 
  group_by(Month, HBName, DepartmentType, Week) %>% 
  summarize(
    NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE),
    .groups = "drop"
  )

When_Source_AE_InOut <- When_Source_AE %>% 
  group_by(Month, HBName, DepartmentType, InOut) %>% 
  summarize(
    NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE),
    .groups = "drop"
  )

When_Source_AE_Week <- When_Source_AE_Week %>% 
  pivot_wider(
    names_from = Week,
    values_from = NumberOfAttendances
  )

When_Source_AE_InOut <- When_Source_AE_InOut %>% 
  pivot_wider(
    names_from = InOut,
    values_from = NumberOfAttendances
  )

When_Source_AE_Final <- full_join(When_Source_AE_InOut, When_Source_AE_Week, by = c("Month", "DepartmentType", "HBName"))


When_Hour_Data_AE <- get_resource(res_id = "022c3b27-6a58-48dc-8038-8f1f93bb0e78") %>% 
  group_by(Month, HBT, DepartmentType, Hour, Week, InOut) %>% 
  summarize(
    NumberOfAttendances = sum(NumberOfAttendances, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  full_join(HB_Lookup_AE, by = "HBT") %>% 
  select(-HBT) %>% 
  mutate(Month = ymd(paste0(Month, "01")))


  

##### Box Functions

# Function to calculate percentage change
calc_change <- function(current, previous) {
  diff <- current - previous
  pct_change <- ifelse(previous == 0, NA, (diff / previous) * 100)
  
  if (is.na(pct_change)) {
    list(label = "N/A", icon = "", color = "black")
  } else if (pct_change >= 0) {
    list(label = paste0("🔼 ", round(pct_change, 1), "%"), icon = "arrow-up", color = "red")
  } else {
    list(label = paste0("🔽 ", round(abs(pct_change), 1), "%"), icon = "arrow-down", color = "green")
  }
}

# Function to create a value box with change indicator
valueBoxWithChange <- function(title, value, change_info) {
  box_color <- ifelse(change_info$color == "lightgreen", "lightgreen", "red")
  
  div(
    style = "background-color: #336699; padding: 10px; border-radius: 8px; height: 210px;",
    valueBox(
      value = HTML(paste0(
        "<div style='color: white;'>",  
        format(value, big.mark = ","), 
        "<br><small style='color:", change_info$color, "'>", 
        change_info$label, 
        "</small></div>"
      )),
      subtitle = tags$span(style = "color: white;", title),
      color = box_color,
      icon = icon(change_info$icon, class = "white-icon")
    ),
    # Custom CSS to force icon and subtitle text white inside the colored box
    tags$style(HTML("
      /* Override subtitle color */
      .small-box-footer, 
      .small-box h3, 
      .small-box p {
        color: white !important;
      }
      /* Icon white */
      .white-icon {
        color: white !important;
      }
    "))
  )
}

valueBoxWithAbsoluteChange <- function(title, current, previous) {
  diff <- current - previous
  
  # Set change label and color
  change_label <- if (diff < 0) {
    paste0("🔽 ", abs(diff))
  } else if (diff > 0) {
    paste0("🔼 ", diff)
  } else {
    "No change"
  }
  
  change_color <- if (diff < 0) "red" else if (diff > 0) "green" else "white"
  box_color <- if (diff < 0) "red" else if (diff > 0) "green" else "blue"
  
  div(
    style = "background-color: #336699; padding: 10px; border-radius: 8px; height: 210px;",
    valueBox(
      value = HTML(paste0(
        "<div style='color: white;'>",  
        format(current, big.mark = ","), 
        "<br><small style='color:", change_color, "'>", 
        change_label, 
        "</small></div>"
      )),
      subtitle = tags$span(style = "color: white;", title),
      color = box_color,
      icon = icon("clock", class = "white-icon")
    ),
    # White icon style
    tags$style(HTML("
      .white-icon {
        color: white !important;
      }
      .small-box p {
        color: white !important;
      }
    "))
  )
}


HB_Department_Type_List <- Monthly_AE_Demographic_Data %>% 
  select(HBName, DepartmentType) %>% 
  unique()
