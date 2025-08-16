AE_Demographic <- conditionalPanel(
  condition= 'input.ae_recent_select == "Recent_AE_Demographic_Tab"',
  
  uiOutput("currentAEHeadersummaryDemographic"),
  
  div(
    style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
  fluidRow(
    column(3,div(class = "custom-select", selectInput("HBName_Current_AE_Demographic", "Select Health Board", 
                                                      choices = unique(WeeklyAE_Healthboard$HBName)))),
    
    uiOutput("ae_department_type_filter"),
    
    column(3,
           div(class = "custom-select",
               selectInput("measure_type_demo_ae", "Select Demographic Type",
                           choices = c("Deprivation", "Age", "Sex"),
                           selected = "Deprivation")))
    
  ),# This ends the whole dashboard filters filter row
  
    br(),
    uiOutput("Deprivation_Boxes_AE"),
    br(),
  
  ), ## end of division for summary boxes 
  br(),
  uiOutput("demographic_line_graph_title"),
  br(),
  div(
    style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
    
    fluidRow(
      column(12,
             plotlyOutput("demographic_graph_output", height = "600px")
      )
    )
  ), ### end of division graph 1
  br(),
  
  uiOutput("demographic_bar_graph_title"),
  br(),
  div(
    style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
  
  uiOutput("dynamic_filter_ui"),
  
  fluidRow(
    column(12,
           plotlyOutput("demographic_bar_graph_output", height = "600px")
    )
  )
  ), ### end of division graph 2

  
) # End of Conditional Panel