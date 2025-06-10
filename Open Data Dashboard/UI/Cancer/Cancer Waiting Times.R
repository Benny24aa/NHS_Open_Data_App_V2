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
                                                       h2("Scottish Cancer Waiting Times Landing Page", style = "color:  #336699 ; font-weight: 600"))),
                                              
                                              fluidRow(
                                                column(6, actionButton("new_next", tags$b("New content and future updates"),
                                                                       icon = icon('calendar-alt')))),
                                              
                                              fluidRow(
                                                column(12,
                                                       h4(tags$b("Background Information", style = "color:  #336699 ; font-weight: 600" )),
                                                       p("Cancer Waiting Times statistics for the 62-day standard for patients urgently referred with a suspicion of cancer to first cancer treatment and for the 31-day standard for patients regardless of the route of referral from date decision to treat to first cancer treatment. Includes data presented by NHS Board and Cancer Type."),
                                                       
                                                       
                                                       h4(tags$b("Open Source Code Information" , style = "color:  #336699 ; font-weight: 600")),
                                                       p("This GitHub repository hosts the full source code for an interactive dashboard that visualizes Cancer Waiting Times (CWT) statistics in Scotland, as reported by NHS Scotland and Public Health Scotland."),
                                                       p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/Scotland-Cancer-RShiny-Dashboard", icon("github"),
                                                                                                                                                   "", target="_blank"), ), 
                                                    
                                                       h4(tags$b(" Disclosure and Data Security Statement", style = "color:  #336699 ; font-weight: 600")),
                                                       p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information.")),
                                              )#End of Fluid Row
                                            ), ### End of conditional Panel
                                            
                                            conditionalPanel(
                                              condition= 'input.cancer_waiting_time_select == "31_Days_Standards"',
                                              
                                              fluidRow(
                                                column(6,
                                                       h2("31 Days Waiting Time Standard Overview", style = "color:  #336699 ; font-weight: 600"))),
                                              
                                              fluidRow(
                                                
                                                column(3, selectInput("hb_name_waiting_times", label = "Select Healthboard",
                                                                      choices = unique(HB_List$HBName,
                                                                                       multiple = TRUE))),
                                                
                                                column(3, selectInput("Cancer_Type_Input_Waiting_Times_Select", label = "Select the cancer type you wish to explore",
                                                                      choices = unique(Cancer_Waiting_Times_31_days_T$CancerType,
                                                                                       multiple = TRUE)))),
                                                
                                          uiOutput("Text_31_Days_Eligible_Referals"),
                                              fluidRow(
                                                column(3, plotlyOutput("cancer_waiting_list_overview_31_days", width = "400%", height = "600px"))),
                                              
                                               

                                               fluidRow(
                                                 column(3, selectInput("Cancer_Quarter_Waiting_Times", label = "Select Data Type",
                                                                       choices = unique(Cancer_Waiting_Times_31_days_T$Quarter,
                                                                                       multiple = TRUE)))),
                                              
                                              fluidRow(
                                                column(3, plotlyOutput("cancer_waiting_list_overview_31_days_treatmenthb", width = "400%", height = "600px"))),

                                              fluidRow(
                                                column(3, plotlyOutput("cancer_waiting_list_overview_31_days_treatmenthb_compare", width = "400%", height = "600px"))
                                              )
                                            ), ### End of conditional panel
                                            
                                            conditionalPanel(
                                              condition= 'input.cancer_waiting_time_select == "62_Days_Standard"',
                                              
                                              fluidRow(
                                                column(6,
                                                       h2("62 Days Waiting Time Standard Overview", style = "color:  #336699 ; font-weight: 600"))),
                                              
                                              fluidRow(
                                                
                                                column(3, selectInput("hb_name_waiting_times", label = "Select Healthboard",
                                                                      choices = unique(HB_List$HBName,
                                                                                       multiple = TRUE))),
                                                
                                                column(3, selectInput("Cancer_Type_Input_Waiting_Times_Select_62", label = "Select the cancer type you wish to explore",
                                                                      choices = unique(Cancer_Waiting_Times_62_days_T$CancerType,
                                                                                       multiple = TRUE)))),
                                              
                                              
                                              fluidRow(
                                                column(3, plotlyOutput("cancer_waiting_list_overview_62_days", width = "400%", height = "600px"))),
                                              
                                              
                                              
                                              fluidRow(
                                                column(3, selectInput("Cancer_Quarter_Waiting_Times_62", label = "Select Data Type",
                                                                      choices = unique(Cancer_Waiting_Times_62_days_T$Quarter,
                                                                                       multiple = TRUE)))),
                                              
                                              fluidRow(
                                                column(3, plotlyOutput("cancer_waiting_list_overview_62_days_treatmenthb", width = "400%", height = "600px"))),
                                              
                                              fluidRow(
                                                column(3, plotlyOutput("cancer_waiting_list_overview_62_days_treatmenthb_compare", width = "400%", height = "600px")))
                                              
                                              
                                              
                                            ), ### End of conditional Panel
                                            
                                
                                            
                                            conditionalPanel(
                                              condition= 'input.cancer_waiting_time_select == "Cancer_Waiting_Times_Download"',
                                              
                                              h2("Select the dataset you wish to download", style = "color: #336699 ; font-weight: 600"),
                                              p("This section allows you to view error data in table format. You can use the filters to select the data you're interested in and download it into a csv format using the download button."),
                                              column(6, selectInput("cancer_waiting_list_download_select", "Select the data you want to explore.",
                                                                    choices = cancer_waiting_list_download_list)),
                                              mainPanel(width = 12,
                                                        DT::dataTableOutput("data_download_cancer_waiting_list_table_filtered")),
                                              column(6, downloadButton('download_table_csv_waiting_list', 'Download data')),
                                            ),#end of conditional panel
                                            
                                            
                                  ))) #End of TabPanel