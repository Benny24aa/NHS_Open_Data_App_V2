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
    WeekEndingDate = lubridate::ymd(WeekEndingDate),
    WeekNum = lubridate::week(WeekEndingDate),
    Year = lubridate::year(WeekEndingDate)
  )

setDT(Respiratory_Diseases) 

resp_month_avg <- Respiratory_Diseases %>%
  mutate(MonthNum = month(WeekEndingDate)) %>%
  filter(Year > "2022") %>% 
  select(-Year) %>% 
  group_by(WeekNum, HBT, Pathogen) %>%
  summarise(across(starts_with("NumberCasesPerWeek"),
                   mean,
                   na.rm = TRUE)) %>% 
  ungroup()

resp_week_avg_wide <- resp_month_avg %>%
  pivot_wider(
    names_from  = Pathogen,
    values_from = starts_with("NumberCasesPerWeek"),
    names_prefix = "NumberCasesPerWeek_"
  )

resp_month_avg_rates <- Respiratory_Diseases %>%
  mutate(MonthNum = month(WeekEndingDate)) %>%
  filter(Year > "2022") %>% 
  select(-Year) %>% 
  group_by(WeekNum, HBT, Pathogen) %>%
  summarise(across(starts_with("RateCasesPerWeek"),
                   mean,
                   na.rm = TRUE)) %>% 
  ungroup()

resp_week_avg_wide_rates <- resp_month_avg_rates %>%
  pivot_wider(
    names_from  = Pathogen,
    values_from = starts_with("RateCasesPerWeek"),
    names_prefix = "RateCasesPerWeek_"
  )



Respiratory_Diseases <- dcast(
  Respiratory_Diseases,
  WeekEndingDate + HBT ~ Pathogen,
  value.var = c("NumberCasesPerWeek", "RateCasesPerWeek")
)

Respiratory_Diseases[is.na(Respiratory_Diseases)] <- 0 ### This is because covid didn't exist pre 2020

############## NOTE TO SELF, these are being created to replace the distinct value which will just repeat itself after the actual data runs out EG, 2026-02-22 data is the last, then the rest just copies this
