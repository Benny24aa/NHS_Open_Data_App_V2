source("UI/A&E/A&E Current Week Sub Scripts/Recent AE Waiting Times.R")
source("UI/A&E/A&E Current Week Sub Scripts/AE Demographic UI.R")
source("UI/A&E/A&E Current Week Sub Scripts/AE Referral Source.R")

CurrentAEUI <- tabPanel(
  title = "Most Recent Accident and Emergency Statistics", 
  icon = icon("car-on"),
  
  # Header (stays outside the blue box)
  fluidRow(
    column(6,
           h2("Most Recent Accident and Emergency Statistics", style = "color: #336699; font-weight: 600"))
  ),
  
  h4("Accident and Emergency (A&E) statistics in Scotland track unplanned attendances at emergency departments for urgent care. They include data on the number of attendances, waiting times, and how many patients are seen within the 4-hour target. Published by Public Health Scotland, these figures help monitor demand, performance, and pressures on emergency services across the country. Each section on this tab looks at data over the last five years, if you wish to see post 2021 data, use the historical accident and emergency tab. Use the filter provided below to change between Health Boards."),
  
  br(),
  radioGroupButtons(
    inputId = "ae_recent_select",
    choices = ae_recent_list,
    status = "primary",
    direction = "horizontal",
    justified = TRUE,
    size = "lg" 
  ),
  br(),
  
  
  AE_Recent_Waiting_Times,
  AE_Demographic,
  AE_Referral_Source
)