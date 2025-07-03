Cancer_Compare <- conditionalPanel(
  condition= 'input.cancer_dashboard_select == "Cancer_Comparison"',
  
  
  fluidRow(
    column(6,
           h2("Health Board Comparison", style = "color:  #336699 ; font-weight: 600"))),
  h4("Health Board Comparison for Cancer Incidence and Mortality Data provides the user the ability to compare Health Boards using different incidators such as EASR and Crude Rates. Please use the filters above the graph to aid you. Click on the legend on the side of the graph to keep or remove Health Boards at your leisure. "),
  
  
  fluidRow(
    
    
    column(3, selectInput("datatype_input_compare", label = "Select data you wish to view",
                          choices = unique(Cancer_Data_Type$DataType,
                                           multiple = TRUE))),
    
    column(3, selectInput("graphtype_input_compare", label = "Select statistical graph type",
                          choices = unique(GraphTypeOptions$Graph_Types,
                                           multiple = TRUE))),
    
    column(3, selectInput("Cancer_Type_Input_compare", label = "Select the cancer type you wish to explore",
                          choices = unique(cancer_types$CancerSite,
                                           multiple = TRUE))),
    
    
    column(3,
           pickerInput(
             inputId = "Healthboard_Input_compare",
             label = "Select Health Boards",
             choices = unique(HB_List$HBName),
             selected = head(unique(HB_List$HBName), 3), 
             multiple = TRUE,
             options = list(
               `actions-box` = TRUE,
               `live-search` = TRUE,
               `selected-text-format` = "count > 3"
             )
           )
    )
    
    
  ),
  
  fluidRow(
    column(3, plotlyOutput("hb_compare_graph", width = "400%", height = "600px")))
  
  
  
)