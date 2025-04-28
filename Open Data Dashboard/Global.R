library(shinyWidgets)

##### Sourcing Reference Files 
source("Global/Geo File.R")

#### Sourcing Download Table Lists
source("Global/Data Download Lists.R")

##### Sourcing in Cancer Data
source("Global/Cancer/Incidence and Mortality.R")

gender_palette <- c("Male" = "#0078D4",
                    "Female" = "#E1C7DF" )


com_list <- c("Cancer Section" = "Cancer", "Waiting List Section" = "WaitList")

cancer_dashboards <- c("Landing Page" = "Cancer_Landing_Page", "Overview" = "Cancer_Overview", "Comparison" = "Cancer_Comparison", "Download Data" = "Cancer_Download_Data")