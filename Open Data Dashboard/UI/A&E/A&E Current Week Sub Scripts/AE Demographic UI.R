AE_Demographic <- conditionalPanel(
  condition= 'input.ae_recent_select == "Recent_AE_Demographic_Tab"',
  
  div(
    style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
  fluidRow(
    column(3,div(class = "custom-select", selectInput("HBName_Current_AE_Demographic", "Select Health Board", 
                                                      choices = unique(WeeklyAE_Healthboard$HBName)))),
    
    column(3,
           div(class = "custom-select",
               selectInput("AE_Department_Type_Input", "Select Department Type", 
                           choices = unique(AE_Department_Type_Options$DepartmentType)))
    )
  
  )  
  ) ## end of division for summary boxes 
  
) # End of Conditional Panel