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

options(httr_config = httr::config(ssl_verifypeer = FALSE))
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

gender_palette <- c("Male" = "#0078D4",
                    "Female" = "#E1C7DF")


com_list <- c("Cancer Mortality" = "Cancer_Mortality_Section", "Cancer Incidence" = "Cancer_Incidence_Section", "Cancer 31 Day Standard" = "Cancer_Waiting_List_31_Day_Section", "Cancer 62 Day Standard" = "Cancer_Waiting_List_62_Day_Section")

cancer_dashboards <- c("Landing Page" = "Cancer_Landing_Page", "Overview" = "Cancer_Overview", "Comparison" = "Cancer_Comparison", "Statistical Analysis" = "Cancer_Statistics", "Download Data" = "Cancer_Download_Data")

cancer_waiting_times <- c("Landing Page" = "Cancer_Waiting_Time_Page", "31 Days Standard" = "31_Days_Standards", "62 Days Standard" = "62_Days_Standard", "Download Data" = "Cancer_Waiting_Times_Download")

diagnostics_dashboard_list <- c("Landing Page" = "Diagnostics_Landing_Page", "Overview" = "Diagnostics_Healthboard_Overview", "Comparison" = "Diagnostics_Healthboard_Comparison", "Download Data" = "Diagnostics_Download_Data")

ae_recent_list <- c("Weekly Waiting Times" = "Recent_AE_Tab",  "Demographics" = "Recent_AE_Demographic_Tab", "Referral Source" = "Recent_AE_Referral_Tab", "Discharge" = "Recent_AE_Discharge_Tab", "When" = "Recent_AE_When_Tab", "Multiple Attendances" = "Recent_AE_Multi_Attend_Tab")
### Commentary and Metadata data files

Cancer_Metadata_Mortality <- read_csv("Metadata Files/Cancer Mortality Metadata.csv")
Cancer_Metadata_Incidence <- read_csv("Metadata Files/Cancer Incidence Metadata.csv")
Cancer_31day_Metadata <- read_csv("Metadata Files/Cancer 31 Day Standard Cancer Metadata.csv")
Cancer_62day_Metadata <- read_csv("Metadata Files/Cancer 62 Day Standard Cancer Metadata.csv")