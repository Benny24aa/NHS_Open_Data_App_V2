Diagnsotics_UI <- tabPanel(title = "Diagnostics Waiting Times",  icon = icon("microscope"),
                            
                            
                            sidebarLayout(
                              sidebarPanel(width = 2,
                                           radioGroupButtons("diagnostics_dashboard_select",
                                                             choices = diagnostics_dashboard_list, status = "primary",
                                                             direction = "vertical", justified = T)),
                              mainPanel(width = 10,
                                        
                                        conditionalPanel(
                                          condition= 'input.diagnostics_dashboard_select == "Diagnostics_Download_Data"',
                                          
                                          h2("Select the dataset you wish to download", style = "color: #336699 ; font-weight: 600"),
                                          p("This section allows you to view error data in table format. You can use the filters to select the data you're interested in and download it into a csv format using the download button."),
                                          column(6, selectInput("diagnostics_download_select", "Select the data you want to explore.",
                                                                choices = diagnostics_download_list)),
                                          mainPanel(width = 12,
                                                    DT::dataTableOutput("data_download_diagnostics_table_filtered")),
                                          column(6, downloadButton('download_table_diagnostics_csv', 'Download data')),
                                        ),#end of conditional panel
                                        
                                        conditionalPanel(
                                          condition= 'input.diagnostics_dashboard_select == "Diagnostics_Landing_Page"',
                                          
                                          fluidRow(
                                            column(6,
                                                   h2("Diagnostics Waiting Times Landing Page", style = "color:  #336699 ; font-weight: 600"))),
                                          
                                          fluidRow(
                                            column(6, actionButton("new_next", tags$b("New content and future updates"),
                                                                   icon = icon('calendar-alt')))),
                                          
                                          fluidRow(
                                            column(12,
                                                   
                                                   h4(tags$b("Background Information", style = "color:  #336699 ; font-weight: 600" )),
                                                   p("This dashboard presents monthly data on how long patients in Scotland have been waiting for eight key diagnostic tests, such as MRI, CT scans, and endoscopies. The data is reported by NHS Boards and shows the number of patients still waiting, grouped by waiting time bands (from under 1 week to over 52 weeks).

Use this dashboard to explore waiting times by health board, test type, and how they compare to national standards. Data is sourced from Public Health Scotland and updated regularly.

"),
                                                   
                                                   h4(tags$b("Open Source Code Information" , style = "color:  #336699 ; font-weight: 600")),
                                                   p("This GitHub repository contains the complete source code for an interactive web dashboard designed to visualize diagnostics statistics across Healthboard."),
                                                   
                                                   p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/NHS_Open_Data_App_V2", icon("github"),
                                                                                                                                               "", target="_blank"), ), 
                                                   h4(tags$b(" Disclosure and Data Security Statement", style = "color:  #336699 ; font-weight: 600")),
                                                   p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information.")),
                                          )#End of Fluid Row
                                          
                                          
                                        ),#end of conditional panel
                                        
                                        conditionalPanel(
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
  column(11, plotlyOutput("diagnostics_overview_graph", height = "600px")),
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
) # end of fluidRow
                                          
                                         
                                          
                                          
                                          
                                        
                                        
                                        
                                        
                              )# end of conditional panel
                              
                              )))