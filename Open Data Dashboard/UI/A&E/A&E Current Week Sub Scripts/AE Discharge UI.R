AE_Discharge_Source <- conditionalPanel(
  condition= 'input.ae_recent_select == "Recent_AE_Discharge_Tab"',
  
  # uiOutput("currentAEHeadersummaryRef"),
  
  div(
    style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
    fluidRow(
      column(3,div(class = "custom-select", selectInput("HBName_Current_AE_Discharge", "Select Health Board", 
                                                        choices = unique(WeeklyAE_Healthboard$HBName)))),
      
      column(3,div(class = "custom-select", selectInput("Discharge_AE_Department_Age", "Select Age Group", 
                                                        choices = unique(AE_Discharge_Age$Age)))),
      
       uiOutput("ae_department_type_discharge_filter"),
      
      
    ),# This ends the whole dashboard filters filter row
    
    br(),
    uiOutput("referral_boxes_discharges"),
    br(),
    
  ), ## end of division for summary boxes 
  br(),
  # uiOutput("ref_line_graph_title"),
  br(),
  div(
    style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
    
    # fluidRow(
    #   column(12,
    #          plotlyOutput("ae_ref_recent_iso_graph", height = "600px")
    #   )
    # )
  ) ### end of division graph 1
  
  
  
) # End of Conditional Panel