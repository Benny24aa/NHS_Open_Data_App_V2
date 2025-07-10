Diagnostics_Comparison_Page <- conditionalPanel(
  condition= 'input.diagnostics_dashboard_select == "Diagnostics_Healthboard_Comparison"',

  
  
  fluidRow(
    column(6,
           h2("Health Board Comparison", style = "color:  #336699 ; font-weight: 600"))),
  h4("Health Board Comparison for Diagnostics Data provides the user the ability to compare Health Boards by looking at Crude Rates for the number of people on the waiting list for a defined period of time. Please use the filters above the graph to aid you. "),
  
  
  
  fluidRow(
    
    column(2,
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
             ))),
    
    column(2, selectInput("diagnostics_waiting_times_input_compare", label = "Select Waiting Time Period",
                          choices = unique(diagnostics_waiting_time_filter_list$WaitingTime,
                                           multiple = FALSE))),
    
    column(2, selectInput("diagnostics_test_type_input_compare", label = "Select Diagnostic Type",
                          choices = unique(diagnostics_test_type_list$DiagnosticTestType,
                                           multiple = FALSE))),
    column(2, uiOutput("diagnostics_description_filter_compare")),
    column(2, selectInput("graphtype_input_compare_diagnostics", label = "Select statistical graph type",
                          choices = unique(Graph_Types_Diagnostics$Graph_Types_Diagnostics,
                                           multiple = TRUE))),
 
    fluidRow(
      column(3, withSpinner(plotlyOutput("hb_compare_diagnostics_graph", width = "400%", height = "600px")), type = 4, color = "blue", size = 1.5)
      
      
      )
   
    
) ### End of fluidRow

  
  
  
  
  
)