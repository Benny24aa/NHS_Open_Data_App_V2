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
library(sf)
library(shiny)
library(glue)
library(phsopendata)
library(data.table)


Respiratory_Diseases <- get_resource(res_id = "212412ba-cff2-43b9-bd40-f8d80688d8bf") %>% 
  select(WeekEnding, Pathogen, HBcode, NumberCasesPerWeek, RateCasesPerWeek) %>% 
  rename(WeekEndingDate = WeekEnding, HBT = HBcode)


Respiratory_Diseases <- Respiratory_Diseases %>%
  mutate(
    WeekEndingDate = lubridate::ymd(WeekEndingDate)
  )

setDT(Respiratory_Diseases) 

wide_df <- dcast(
  Respiratory_Diseases,
  WeekEndingDate + HBT ~ Pathogen,
  value.var = c("NumberCasesPerWeek", "RateCasesPerWeek")
)

wide_df[is.na(wide_df)] <- 0 ### This is because covid didn't exist pre 2020