dir.create("cache", showWarnings = FALSE)
app_start_time <- Sys.time()
cat("App startup initiated at:", format(app_start_time), "\n")
library(shinyWidgets)
library(zoo)
library(leaflet)
library(sf)
library(shinyjs)
library(rsconnect)
library(curl)
library(httr)
library(openssl)
library(shinycssloaders)
library(ISOweek)
library(janitor)
library(shiny)
library(glue)
#### Databrick Related Libraries
library(DBI)
library(odbc)
library(Metrics)
library(jsonlite)
library(pins)

board <- board_folder("cache")

pin_write(board, data, "dataset")
data <- pin_read(board, "dataset")
options(httr_config = httr::config(ssl_verifypeer = FALSE))

warm_cache <- function(file, download_fun, max_age_days = 14){
  
  if(file.exists(file)){
    
    age <- difftime(Sys.time(), file.info(file)$mtime, units = "days")
    
    if(age < max_age_days){
      message("Loading cached data: ", file)
      return(readRDS(file))
    }
    
  }
  
  message("Refreshing cache: ", file)
  
  data <- download_fun()
  
  saveRDS(data, file)
  
  data
}

##### Sourcing Reference Files 
source("Global/Geo File.R")

#### Sourcing Download Table Lists
source("Global/Data Download Lists.R")

##### Sourcing in Cancer Data
source("Global/Cancer/Incidence and Mortality.R")
source("Global/Cancer/Waiting Times.R")

#### Sourcing in Diagnostics Data
source("Global/Diagnostics Waiting Times/Diagnostics.R")

#### Sourcing in Weekly A&E Data
source("Global/A&E/Weekly A&E/Weekly A&E Data.R")

### Sourcing in AI Workflow Data (External Databricks Pipeline)
# source("Global/AI Workflow/AI Workflow.R")

### Sourcing in combined forecast from XGBoost Posit Connect Output
source("Global/AI Workflow/Posit Connect XGBoost Output.R")


gender_palette <- c("Male" = "#0078D4",
                    "Female" = "#E1C7DF")


com_list <- c("Cancer Mortality" = "Cancer_Mortality_Section", "Cancer Incidence" = "Cancer_Incidence_Section", "Cancer 31 Day Standard" = "Cancer_Waiting_List_31_Day_Section", "Cancer 62 Day Standard" = "Cancer_Waiting_List_62_Day_Section")

cancer_dashboards <- c("Landing Page" = "Cancer_Landing_Page", "Overview" = "Cancer_Overview", "Comparison" = "Cancer_Comparison", "Statistical Analysis" = "Cancer_Statistics", "Download Data" = "Cancer_Download_Data")

cancer_waiting_times <- c("Landing Page" = "Cancer_Waiting_Time_Page", "31 Days Standard" = "31_Days_Standards", "62 Days Standard" = "62_Days_Standard", "Download Data" = "Cancer_Waiting_Times_Download")

diagnostics_dashboard_list <- c("Landing Page" = "Diagnostics_Landing_Page", "Overview" = "Diagnostics_Healthboard_Overview", "Comparison" = "Diagnostics_Healthboard_Comparison", "Download Data" = "Diagnostics_Download_Data")

ae_recent_list <- c("Weekly Waiting Times" = "Recent_AE_Tab",  "Demographics" = "Recent_AE_Demographic_Tab", "Referral Source" = "Recent_AE_Referral_Tab", "Discharge" = "Recent_AE_Discharge_Tab", "When" = "Recent_AE_When_Tab")
### Commentary and Metadata data files

random_forest_list <- c("Outliers" = "Outlier_Tab_RF", "Prediction Tab" = "Predition_Tab_RF")


Cancer_Metadata_Mortality <- read_csv("Metadata Files/Cancer Mortality Metadata.csv")
Cancer_Metadata_Incidence <- read_csv("Metadata Files/Cancer Incidence Metadata.csv")
Cancer_31day_Metadata <- read_csv("Metadata Files/Cancer 31 Day Standard Cancer Metadata.csv")
Cancer_62day_Metadata <- read_csv("Metadata Files/Cancer 62 Day Standard Cancer Metadata.csv")

HealthBoards_shp <- warm_cache(
  "cache/healthboards_shp.rds",
  function(){
    st_read("Scottish Healthboards/SG_NHS_HealthBoards_2019.shp") %>%
      st_transform(crs = 4326) %>%
      st_simplify(dTolerance = 2000) %>% 
      mutate(HBName = paste("NHS", HBName))
  }
)

Weeks_AE_Map <- WeeklyAE_Healthboard %>% 
  distinct(WeekEndingDate) %>% 
  arrange(desc(WeekEndingDate)) %>% 
  slice(1:6)

Populations_Brackets <- warm_cache(
  "cache/population_data.rds",
  function(){
    get_resource(res_id = "0876fc67-05e6-4e87-bc30-c4b0756fff04")
  }
) %>% 
  select(-HBQF, -SexQF) %>% 
  mutate(
    Year = ym(paste0(Year, "01")),
    Year = year(Year)
  ) %>%
  full_join(HB_Lookup_AE, by = c("HB" = "HBT"))  %>%
  filter(!is.na(HBName)) %>% 
  filter(Sex == "All") %>% 
  select(-Sex, -HB) %>%
  filter(Year >= 2018 & Year <= year(Sys.Date())) %>% 
  mutate(
    `Under 18` = rowSums(select(., starts_with("Age0"):Age17), na.rm = TRUE),
    `18-24`    = rowSums(select(., Age18:Age24), na.rm = TRUE),
    `25-39`    = rowSums(select(., Age25:Age39), na.rm = TRUE),
    `40-64`    = rowSums(select(., Age40:Age64), na.rm = TRUE),
    `65-74`    = rowSums(select(., Age65:Age74), na.rm = TRUE),
    `75 plus`  = rowSums(select(., Age75:Age90plus), na.rm = TRUE)
  ) %>%
  select(Year, HBName, `Under 18`:`75 plus`) %>%
  pivot_longer(
    cols = `Under 18`:`75 plus`,
    names_to = "Age",
    values_to = "Population"
  )

##### AI Model Inputs

# Random_Forest_Model_Inputs <- c("none", "impurity", "impurity_corrected", "permutation")
# Random_Forest_Model_Inputs <- data.frame(Random_Forest_Model_Inputs)

######################### Plain Value Boxes

RFValueBox <- function(title, value, box_color = "blue", icon_name = "chart-line") {
  div(
    style = paste0("background-color: ", box_color, "; padding: 10px; border-radius: 8px; height: 210px;"),
    valueBox(
      value = HTML(paste0(
        "<div style='color: white;'>",
        format(value, big.mark = ","),
        "</div>"
      )),
      subtitle = tags$span(style = "color: white;", title),
      color = box_color,
      icon = icon(icon_name, class = "white-icon")
    ),
    tags$style(HTML("
      /* Force text and icon white */
      .small-box-footer,
      .small-box h3,
      .small-box p {
        color: white !important;
      }
      .white-icon {
        color: white !important;
      }
    "))
  )
}

##### Loading in most recent GP Data into dashboard

# CKAN base
ckan_base <- "https://www.opendata.nhs.scot/api/3/action"

# Package ID: GP Practice Contact Details and List Sizes
pkg_id <- "f23655c3-6e23-4103-a511-a80d998adb90"

# Get dataset metadata
pkg <- fromJSON(
  content(
    GET(paste0(ckan_base, "/package_show?id=", pkg_id)),
    "text",
    encoding = "UTF-8"
  )
)

# Find latest CSV resource
latest_resource <- pkg$result$resources %>%
  filter(grepl("csv", format, ignore.case = TRUE)) %>%
  mutate(last_mod = as.POSIXct(last_modified)) %>%
  arrange(desc(last_mod)) %>%
  slice(1)

# Reads this into from CKAN
gp_practice_data <- warm_cache(
  "cache/gp_practice_data.rds",
  function(){
    read.csv(latest_resource$url, stringsAsFactors = FALSE)
  }
)

#### For most recent dispenser Data

pkg_id_disp <- "a30fde16-1226-49b3-b13d-eb90e39c2058"

# Get dataset metadata
pkg_disp <- fromJSON(
  content(
    GET(paste0(ckan_base, "/package_show?id=", pkg_id_disp)),
    "text",
    encoding = "UTF-8"
  )
)

# Find latest CSV resource
latest_resource_disp <- pkg_disp$result$resources %>%
  filter(grepl("csv", format, ignore.case = TRUE)) %>%
  mutate(last_mod = as.POSIXct(last_modified)) %>%
  arrange(desc(last_mod)) %>%
  slice(1)

# Reads this into from CKAN
disp_data <- warm_cache(
  "cache/disp_data.rds",
  function(){
    read.csv(latest_resource_disp$url, stringsAsFactors = FALSE)
  }
)

startup_time <- Sys.time() - app_start_time
cat("App startup completed in:", round(startup_time, 2), "seconds\n")