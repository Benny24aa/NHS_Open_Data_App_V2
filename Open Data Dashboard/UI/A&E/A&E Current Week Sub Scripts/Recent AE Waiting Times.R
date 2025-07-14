AE_Recent_Waiting_Times <- conditionalPanel(
  condition= 'input.ae_recent_select == "Recent_AE_Tab"', 
  
  uiOutput("currentAEHeadersummary"),
  
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
    font-size: 18px;
  }
")),
    
    fluidRow(
      column(3,div(class = "custom-select", selectInput("HBName_Current_AE", "Select Health Board", 
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
  ),
  br(),
  div(
    style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
    
    
    tags$style(HTML("
  .custom-select-ae-graph .form-group {
    background-color: #f0f0f0 !important;
  }

  .custom-select-ae-graph .selectize-control {
    background-color: #f0f0f0 !important;
  }

  .custom-select-ae-graph .selectize-input {
    background-color: #cce5ff !important;
    color: #254a7c !important;
    font-weight: bold;
    border: 1px solid #999999;           /* Grey border */
    border-radius: 4px;
  }

  .custom-select-ae-graph .selectize-dropdown {
    background-color: #white !important;
  }

  .custom-select-ae-graph .selectize-dropdown-content .option {
    color: #254a7c !important;
    font-weight: bold;
  }

  .custom-select-ae-graph label {
    color: #003366 !important;
    font-weight: bold;
    font-size: 18px;
  }
")),
    
    
    
    fluidRow(
      
      
     
      column(3, 
             div(class = "custom-select-ae-graph", selectInput(
               inputId = "ae_recent_measure_select",
               label = "Select Measure",
               choices = c(
                 "Total Attendances" = "TotalAttendances",
                 "Over 4 Hours" = "TotalOver4Hours",
                 "Over 8 Hours" = "TotalOver8Hours",
                 "Over 12 Hours" = "TotalOver12Hours",
                 "Within 4 Hours" = "TotalWithin4Hours"
               ),
               selected = "TotalAttendances"
             ))
      )
    ),
    
    fluidRow(
      column(12,
             plotlyOutput("ae_recent_iso_graph", height = "600px")
      )
    )
  )
  
) # end of conditional panel