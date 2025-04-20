library(shiny)
library(shinyWidgets)
library(DT)
library(data.table)
library(ggplot2)
library(shinydashboard)
library(readr)
library(dplyr)
library("readxl")
library("RColorBrewer")
library(rsconnect)
library(base)
library(datasets)
library(graphics)
library(grDevices)
library(methods)
library(readr)
library(readxl)
library(RColorBrewer)
library(stats)
library(utils)
library(sf)
library(writexl)
library(base64enc)
library(phsopendata)
library(plotly)
library(crosstalk)
library(lubridate)
library(kableExtra)
library(tidyverse)


HB_Lookup <- get_resource(res_id = "652ff726-e676-4a20-abda-435b98dd7bdc")
Council_Lookup <- get_resource(res_id = "967937c4-8d67-4f39-974f-fd58c4acfda5")
Interminate_Zone_Lookup <- get_resource(res_id = "e3e885cc-2530-4b3c-bead-9eda9782264f")
Data_Zone_Lookup  <- get_resource(res_id = "395476ab-0720-4740-be07-ff4467141352")
Hospital_Lookup <- get_resource(res_id = "c698f450-eeed-41a0-88f7-c1e40a568acc")

HB_Lookup <- HB_Lookup |>
  select(-Country,-HBDateEnacted)|>
  filter(is.na(HBDateArchived))|>
  select(-HBDateArchived) %>% 
  mutate(GeoType = "Health Board") 

Council_Lookup <- Council_Lookup %>% 
  select(CA, CAName, CADateArchived) %>% 
  filter(is.na(CADateArchived))|>
  select(-CADateArchived) %>% 
  mutate(GeoType = "Council Area") %>% 
  rename(GeoCode = CA, GeoName = CAName)

Council_Lookup <- Council_Lookup %>% 
  distinct()

Interminate_Zone_Lookup <- Interminate_Zone_Lookup %>% 
  select(IntZone, IntZoneName, HB) %>% 
  mutate(GeoType = "Interminate Zone") %>% 
  rename(GeoCode = IntZone, GeoName = IntZoneName)

Hospital_Lookup <- Hospital_Lookup %>% 
  select(HospitalCode, HospitalName, HealthBoard) %>% 
  mutate(GeoType = "Hospital") %>% 
  rename(GeoCode = HospitalCode, GeoName = HospitalName, HB = HealthBoard)

Data_Zone_Lookup <- Data_Zone_Lookup %>% 
  select(DataZone, DataZoneName, HB) %>% 
  mutate(GeoType = "Data Zone") %>% 
  rename(GeoCode = DataZone, GeoName = DataZoneName)

Lookup_List <- bind_rows(Council_Lookup, Interminate_Zone_Lookup, Hospital_Lookup, Data_Zone_Lookup)

#### List for HB Filter on top of Information Page

HB_List <- HB_Lookup %>% 
  select(HBName) %>% 
  arrange(HBName)

HBName <- c("All Scotland Data")
HBName <- data.frame(HBName)

HB_List <- bind_rows(HB_List, HBName)%>% 
  arrange(HBName) 

HB_List <- HB_List %>% 
  filter(HBName != "All Scotland Data")
