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
                                                   p("Coming soon"),
                                                   
                                                   h4(tags$b("Open Source Code Information" , style = "color:  #336699 ; font-weight: 600")),
                                                   p("This GitHub repository contains the complete source code for an interactive web dashboard designed to visualize diagnostics statistics across Healthboard."),
                                                   
                                                   p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/NHS_Open_Data_App_V2", icon("github"),
                                                                                                                                               "", target="_blank"), ), 
                                                   h4(tags$b(" Disclosure and Data Security Statement", style = "color:  #336699 ; font-weight: 600")),
                                                   p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information.")),
                                          )#End of Fluid Row
                                          
                                          
                                        )#end of conditional panel
                                        
                                        
                                        
                              )))