Diagnostics_Healthboard_Overview <- conditionalPanel(
  condition= 'input.diagnostics_dashboard_select == "Diagnostics_Healthboard_Overview"',
  
  fluidRow(
    column(6,
           h2("Health Board Overview", style = "color:  #336699 ; font-weight: 600"))),
  h4("This section provides an overview of diagnostic waiting times for your selected NHS Health Board.
Use the filters to choose a health board, waiting time band, and diagnostic test type. The interactive graph below shows how many patients are waiting for each type of test and how this has changed over time. You can also add trend lines or run chart rules to better understand performance patterns."),
  h4("The run chart rules applied in this dashboard help identify patterns that may indicate meaningful changes in diagnostic waiting times. The shift rule is triggered when six or more consecutive data points fall either entirely above or entirely below the median line, suggesting a sustained change in the system rather than random fluctuation. The trend rule highlights periods where five or more consecutive points are either increasing or decreasing, indicating a consistent upward or downward movement over time. These rules are used to detect possible non-random variation and are marked visually on the chart to support interpretation of performance trends."), 
  
  fluidRow(
    
    column(3, selectInput("hb_name_diagnostics", label = "Select Healthboard",
                          choices = unique(HB_List$HBName,
                                           multiple = FALSE))),
    
    column(3, selectInput("diagnostics_waiting_times_input", label = "Select Waiting Time Period",
                          choices = unique(diagnostics_waiting_time_filter_list$WaitingTime,
                                           multiple = FALSE))),
    
    column(3, selectInput("diagnostics_test_type_input", label = "Select Diagnostic Type",
                          choices = unique(diagnostics_test_type_list$DiagnosticTestType,
                                           multiple = FALSE))),
    column(3, uiOutput("diagnostics_description_filter"))
  ), ### End of fluidRow
  
  
  uiOutput("diagnostics_overview_graph_text"),   
  fluidRow(
    column(11, withSpinner(plotlyOutput("diagnostics_overview_graph", height = "600px")), type = 4, color = "blue", size = 1.5),
    column(1,
           radioButtons(
             "line_option_diagnostics", 
             label = "Choose Analytics", 
             choices = c("None", "Show Average Line", "Show Median Line", "Show Both"), 
             selected = "None",
             width = "100%"
           ),
           checkboxInput(
             "show_run_chart_rules", 
             "Show Run Chart Rules", 
             value = FALSE,
             width = "100%"
           )
    )
  ), # end of fluidRow
  
  uiOutput("diagnostics_overview_graph_percent_change_text"),
  fluidRow(
    column(11, withSpinner(plotlyOutput("diagnostics_overview_graph_percent_change", height = "600px")), type = 4, color = "blue", size = 1.5),
    column(1, selectInput(
      inputId = "diagnostics_chart_type",
      label = "Select Chart Type:",
      choices = c("Bar" = "bar", "Line" = "line"),
      selected = "bar",
      width = "100%"
    )
    
    )
    
  ) ## end of fluid row
  
  
  
  
  
  
  
  
  
)