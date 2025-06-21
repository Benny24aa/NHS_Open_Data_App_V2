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
                                        )#end of conditional panel
                                        
                                        
                                        
                              )))