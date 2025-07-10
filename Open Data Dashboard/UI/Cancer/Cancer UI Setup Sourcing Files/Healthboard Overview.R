Cancer_Overview <- conditionalPanel(
  condition= 'input.cancer_dashboard_select == "Cancer_Overview"',
  
  fluidRow(
    column(6,
           h2("Health Board Overview", style = "color:  #336699 ; font-weight: 600"))),
  h4("Health Board Overview for Cancer Incidence and Mortality Data provides a summary of cancer-related health outcomes across geographic health authority areas in Scotland. It offers key insights into the burden of cancer, how it varies by Health Board, and supports policy planning, resource allocation, and public health interventions. This page includes the ability to filter for different indicators such as Crude Rates and EASR and more for both Incidence and Mortality. Use the filters below to filter for all graphs on this page. "),
  
  
  fluidRow(
    
    column(3, selectInput("hb_name", label = "Select Healthboard",
                          choices = unique(HB_List$HBName,
                                           multiple = FALSE))),
    column(3, selectInput("datatype_input", label = "Select data you wish to view",
                          choices = unique(Cancer_Data_Type$DataType,
                                           multiple = TRUE))),
    
    column(3, selectInput("graphtype_input", label = "Select statistical graph type",
                          choices = unique(GraphTypeOptions$Graph_Types,
                                           multiple = TRUE))),
    
    column(3, selectInput("Cancer_Type_Input", label = "Select the cancer type you wish to explore",
                          choices = unique(cancer_types$CancerSite,
                                           multiple = TRUE)))),
  
  uiOutput("Cancer_Overview"),
  fluidRow(
    column(3, withSpinner(plotlyOutput("scotland_info_graph_server", width = "400%", height = "600px")), type = 4, size = 1.5, color = "blue")   
    
    ),
  uiOutput("Cancer_Sex_Overview"),
  fluidRow(
    column(3, withSpinner(plotlyOutput("scotland_gender_graph_server", width = "400%", height = "600px")), type = 4, size = 1.5, color = "blue")          
    
    )
  
  
)