Cancer_Statistics <- conditionalPanel(
  condition= 'input.cancer_dashboard_select == "Cancer_Statistics"',
  
  fluidRow(
    column(6,
           h2("Health Board Statistics", style = "color:  #336699 ; font-weight: 600"))),
  h4("This dashboard provides a comparative overview of key cancer statistics across Health Boards. It features two interactive visualizations which are a Scatter Plot which displays individual Health Boards as data points, allowing comparison of specific cancer indicators (e.g., incidence, and mortality) by Healthboard. This helps identify outliers or trends across boards.
The other visual is a Box Plot, which summarises the distribution of the same indicators, highlighting medians, quartiles, and any statistical outliers. This gives a clearer view of overall variation and equity in health outcomes.
Use the dropdown filters to customize the view by cancer type, data type (e.g., crude rate, age-standardized rate), and demographic grouping (sex)."),
  
  
  fluidRow(
    
    column(3, selectInput("hb_name", label = "Select Healthboard",
                          choices = unique(HB_List$HBName,
                                           multiple = FALSE))),
    
    column(3, selectInput("Cancer_Type_Input_Stats", label = "Select the cancer type you wish to explore",
                          choices = unique(cancer_types$CancerSite,
                                           multiple = TRUE))),
    
    column(3, selectInput("Cancer_Gender_Input", label = "Select Gender",
                          choices = unique(Cancer_Genders$Sex,
                                           multiple = TRUE)))),
  uiOutput("Cancer_ScatterPlot_Text"),
  fluidRow(
    column(3, plotlyOutput("hb_cancer_outlier", width = "400%", height = "600px"))),
  uiOutput("Cancer_boxplot_Text"),
  fluidRow(
    column(3, selectInput("BoxPlot_Input_Cancer", label = "Select Data Type",
                          choices = unique(GraphTypeOptionsStatsCancer$Graph_Types_Stats_Cancer,
                                           multiple = TRUE)))),
  fluidRow(
    column(3, plotlyOutput("hb_cancer_outlier_box", width = "400%", height = "600px")))
  
  
) #end of conditional panel