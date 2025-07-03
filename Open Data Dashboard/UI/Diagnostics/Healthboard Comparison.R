Diagnostics_Comparison_Page <- conditionalPanel(
  condition= 'input.diagnostics_dashboard_select == "Diagnostics_Healthboard_Comparison"',

  
  
  fluidRow(
    column(6,
           h2("Health Board Comparison", style = "color:  #336699 ; font-weight: 600"))),
<<<<<<< HEAD
  h4("Health Board Comparison for Diagnostics Data provides the user the ability to compare Health Boards by looking at Crude Rates for the number of people on the waiting list for a defined period of time. Please use the filters above the graph to aid you. "),
  
  
  
  fluidRow(
    column(3,
           pickerInput(
             inputId = "Healthboard_Diagnostics_Input_compare",
             label = "Select Health Boards",
             choices = unique(HB_List$HBName),
             selected = head(unique(HB_List$HBName), 3), 
             multiple = TRUE,
             options = list(
               `actions-box` = TRUE,
               `live-search` = TRUE,
               `selected-text-format` = "count > 3"
             )))
    
    
    ) #end of fluid row
  
  
  
  
=======
  h4("Health Board Comparison for Diagnostics Data provides the user the ability to compare Health Boards by looking at Crude Rates for the number of people on the waiting list for a defined period of time. Please use the filters above the graph to aid you. ")
>>>>>>> 32ce0cf1d33d7d4db86697178a713a92a64e8a0d
  
)