Cancer_Waiting_Time_62_Days_Code <- conditionalPanel(
  condition= 'input.cancer_waiting_time_select == "62_Days_Standard"',
  
  fluidRow(
    column(6,
           h2("62 Days Waiting Time Standard Overview", style = "color:  #336699 ; font-weight: 600"))),
  h4("This section provides a summary of NHS Scotland’s performance on cancer waiting times across geographic Health Board areas. It offers key insights into how quickly patients begin treatment following a cancer diagnosis, highlighting regional variation in meeting national waiting time standards. This supports policy planning, performance monitoring, and service improvement efforts across the cancer care pathway.

The page includes the ability to filter for different indicators relating to 62-Day Standard for Cancer Waiting Times. Use the filters below to update all visualizations on this page according to cancer type, Health Board, and time period. "),
  fluidRow(
    
    column(3, selectInput("hb_name_waiting_times", label = "Select Healthboard",
                          choices = unique(HB_List$HBName,
                                           multiple = TRUE))),
    
    column(3, selectInput("Cancer_Type_Input_Waiting_Times_Select_62", label = "Select the cancer type you wish to explore",
                          choices = unique(Cancer_Waiting_Times_62_days_T$CancerType,
                                           multiple = TRUE)))),
  
  uiOutput("Text_62_Days_Eligible_Referals"),
  fluidRow(
    column(3, plotlyOutput("cancer_waiting_list_overview_62_days", width = "400%", height = "600px"))),
  
  
  uiOutput("Text_62_Days_Eligible_Referals_Treated"),
  fluidRow(
    column(3, selectInput("Cancer_Quarter_Waiting_Times_62", label = "Select Data Type",
                          choices = unique(Cancer_Waiting_Times_62_days_T$Quarter,
                                           multiple = TRUE)))),
  
  fluidRow(
    column(3, plotlyOutput("cancer_waiting_list_overview_62_days_treatmenthb", width = "400%", height = "600px"))),
  
  uiOutput("Text_62_Days_Eligible_Referals_Treated_Compare"),
  fluidRow(
    column(3, plotlyOutput("cancer_waiting_list_overview_62_days_treatmenthb_compare", width = "400%", height = "600px")))
  
  
  
)