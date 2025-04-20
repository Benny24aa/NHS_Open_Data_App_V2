Cancer_Mortality_Incidence <- tabPanel(title = "Health Board Overview", 
                        icon = icon("hospital"),
                        
                        fluidRow(
                          column(6,
                                 h2("Health Board Overview", style = "color:  #336699 ; font-weight: 600"))),
                        
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
                     
                        fluidRow(
                          column(3, plotlyOutput("scotland_info_graph_server", width = "400%", height = "600px"))),
                        fluidRow(
                          column(3, plotlyOutput("scotland_gender_graph_server", width = "400%", height = "600px")))
                  

                          
                          
                        )