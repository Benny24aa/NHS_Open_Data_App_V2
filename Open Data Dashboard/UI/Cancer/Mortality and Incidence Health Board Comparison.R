Cancer_Mortality_Incidence_Comparison <- tabPanel(title = "Health Board Comparison", 
                                       icon = icon("hospital"),

fluidRow(
  column(6,
         h2("Health Board Comparison", style = "color:  #336699 ; font-weight: 600"))),

fluidRow(
  
  # column(3,  selectizeInput("hb_name_compare", label = "Select Healthboard",
  #                       choices = unique(HB_List$HBName,
  #                                        multiple = FALSE,
  #                                        selected = HB_List$HBName,
  #                                        options = list( 
  #                                          `actions-box` = TRUE)))),
  # 
 
  
column(3, selectInput("datatype_input_compare", label = "Select data you wish to view",
                      choices = unique(Cancer_Data_Type$DataType,
                                       multiple = TRUE))),

column(3, selectInput("graphtype_input_compare", label = "Select statistical graph type",
                      choices = unique(GraphTypeOptions$Graph_Types,
                                       multiple = TRUE))),

column(3, selectInput("Cancer_Type_Input_compare", label = "Select the cancer type you wish to explore",
                      choices = unique(cancer_types$CancerSite,
                                       multiple = TRUE)))



),

fluidRow(
  column(3, plotlyOutput("hb_compare_graph", width = "400%", height = "600px")))


)