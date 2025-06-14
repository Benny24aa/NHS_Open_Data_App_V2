library(shinyWidgets)
library(zoo)
library(leaflet)
library(sf)
library(shinyjs)
library(rsconnect)
library(curl)
library(httr)
library(openssl)

options(httr_config = httr::config(ssl_verifypeer = FALSE))
##### Sourcing Reference Files 
source("Global/Geo File.R")

#### Sourcing Download Table Lists
source("Global/Data Download Lists.R")

##### Sourcing in Cancer Data
source("Global/Cancer/Incidence and Mortality.R")
source("Global/Cancer/Waiting Times.R")
source("Global/Diagnostics Waiting Times/Diagnostics.R")

gender_palette <- c("Male" = "#0078D4",
                    "Female" = "#E1C7DF")


com_list <- c("Cancer Mortality" = "Cancer_Mortality_Section", "Cancer Incidence" = "Cancer_Incidence_Section", "Cancer 31 Day Standard" = "Cancer_Waiting_List_31_Day_Section", "Cancer 62 Day Standard" = "Cancer_Waiting_List_62_Day_Section")

cancer_dashboards <- c("Landing Page" = "Cancer_Landing_Page", "Overview" = "Cancer_Overview", "Comparison" = "Cancer_Comparison", "Statistical Analysis" = "Cancer_Statistics", "Download Data" = "Cancer_Download_Data")

cancer_waiting_times <- c("Landing Page" = "Cancer_Waiting_Time_Page", "31 Days Standard" = "31_Days_Standards", "62 Days Standard" = "62_Days_Standard", "Download Data" = "Cancer_Waiting_Times_Download")


### Commentary and Metadata data files

Cancer_Metadata_Mortality <- read_csv("Metadata Files/Cancer Mortality Metadata.csv")
Cancer_Metadata_Incidence <- read_csv("Metadata Files/Cancer Incidence Metadata.csv")
Cancer_31day_Metadata <- read_csv("Metadata Files/Cancer 31 Day Standard Cancer Metadata.csv")
Cancer_62day_Metadata <- read_csv("Metadata Files/Cancer 62 Day Standard Cancer Metadata.csv")