Diagnostics_Comparison_Page <- conditionalPanel(
  condition= 'input.diagnostics_dashboard_select == "Diagnostics_Healthboard_Comparison"',

  
  
  fluidRow(
    column(6,
           h2("Health Board Comparison", style = "color:  #336699 ; font-weight: 600"))),
  h4("Health Board Comparison for Diagnostics Data provides the user the ability to compare Health Boards by looking at Crude Rates for the number of people on the waiting list for a defined period of time. Please use the filters above the graph to aid you. ")
  
)