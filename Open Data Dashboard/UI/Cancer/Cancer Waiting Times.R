Cancer_Waiting_List <- tabPanel(title = "Cancer Waiting Times",  icon = icon("microscope"),

                                
                                
                                sidebarLayout(
                                  sidebarPanel(width = 2,
                                               radioGroupButtons("cancer_waiting_time_select",
                                                                 choices = cancer_waiting_times, status = "primary",
                                                                 direction = "vertical", justified = T)),
                                  mainPanel(width = 10,
                                            
                                            conditionalPanel(
                                              condition= 'input.cancer_waiting_time_select == "Cancer_Waiting_Time_Page"',
                                              
                                              fluidRow(
                                                column(6,
                                                       h2("Welcome to the Scottish Open Data Cancer Dashboard", style = "color:  #336699 ; font-weight: 600"))),
                                              
                                              fluidRow(
                                                column(6, actionButton("new_next", tags$b("New content and future updates"),
                                                                       icon = icon('calendar-alt')))),
                                              
                                              fluidRow(
                                                column(12,
                                                       h4(tags$b("?" , style = "color:  #336699 ; font-weight: 600")),
                                                       p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/Scotland-Cancer-RShiny-Dashboard", icon("github"),
                                                                                                                                                   "", target="_blank"), ), 
                                                       h4(tags$b("?", style = "color:  #336699 ; font-weight: 600" )),
                                                       p(""),
                                                       h4(tags$b(" Disclosure and Data Security Statement", style = "color:  #336699 ; font-weight: 600")),
                                                       p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information.")),
                                              )#End of Fluid Row
                                            ), ### End of conditional Panel
                                            
                                            conditionalPanel(
                                              condition= 'input.cancer_waiting_time_select == "31_Days_Standards"',
                                              
                                              fluidRow(
                                                column(6,
                                                       h2("Health Board Overview", style = "color:  #336699 ; font-weight: 600"))),
                                              
                                              fluidRow(
                                                
                                                column(3, selectInput("hb_name_waiting_times", label = "Select Healthboard",
                                                                      choices = unique(HB_List$HBName,
                                                                                       multiple = TRUE))),
                                                
                                                column(3, selectInput("Cancer_Type_Input_Waiting_Times_Select", label = "Select the cancer type you wish to explore",
                                                                      choices = unique(Cancer_Waiting_Times_31_days_T$CancerType,
                                                                                       multiple = TRUE)))),
                                                
                                          
                                              fluidRow(
                                                column(3, plotlyOutput("cancer_waiting_list_overview_31_days", width = "400%", height = "600px"))),
                                              
                                               

                                               fluidRow(
                                                 column(3, selectInput("Cancer_Quarter_Waiting_Times", label = "Select Data Type",
                                                                       choices = unique(Cancer_Waiting_Times_31_days_T$Quarter,
                                                                                       multiple = TRUE)))),
                                              
                                              fluidRow(
                                                column(3, plotlyOutput("cancer_waiting_list_overview_31_days_treatmenthb", width = "400%", height = "600px")))

                                              
                                            )
                                            
                                            
                                  ))) #End of TabPanel