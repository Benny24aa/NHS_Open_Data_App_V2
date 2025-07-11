CurrentAEUI <- tabPanel(
  title = "Most Recent Accident and Emergency Statistics", 
  icon = icon("car-on"),
  
  # Header (stays outside the blue box)
  fluidRow(
    column(6,
           h2("Most Recent Accident and Emergency Statistics", style = "color: #336699; font-weight: 600"))
  ),
  
  h4("Coming Soon"),
  
  # Styled section: filters + value boxes
  div(
    style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
    
    tags$style(HTML("
  .custom-select .form-group {
    background-color: #cce5ff !important;
  }

  .custom-select .selectize-control {
    background-color: #cce5ff !important;
  }

  .custom-select .selectize-input {
    background-color: #cce5ff !important;
    color: #254a7c !important;
    font-weight: bold;
    border: 1px solid #999999;           /* Grey border */
    border-radius: 4px;
  }

  .custom-select .selectize-dropdown {
    background-color: #cce5ff !important;
  }

  .custom-select .selectize-dropdown-content .option {
    color: #254a7c !important;
    font-weight: bold;
  }

  .custom-select label {
    color: #003366 !important;
    font-weight: bold;
    font-size: 16px;
  }
")),
    
    # Filters
    fluidRow(
      column(3,
             div(class = "custom-select",
                 selectInput("HBName_Current_AE", "Select Health Board", 
                             choices = unique(WeeklyAE_Healthboard$HBName)))
      ),
      column(3,
             div(class = "custom-select",
                 selectInput("AttendanceCategory_Current_AE", "Select Category", 
                             choices = unique(WeeklyAE_Healthboard$AttendanceCategory)))
      )
    ),
    
    br(),
    # AE Value Boxes
    uiOutput("currentAEBoxes")
  )
)