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

WeeklyAEDemographics <- get_resource(res_id = "6abbf8e4-e4e0-4a56-a7b9-f7c7b4171ff3") %>% 
  select(-SexQF, -DeprivationQF, -AgeQF, -Country) %>% 
  filter(!is.na(Deprivation)) %>% 
  full_join(HB_Lookup_AE, by = "HBT")%>%
  mutate(
    Month = ym(Month)
  ) %>% 
  select(-HBT) %>% 
  filter(!is.na(Age))


