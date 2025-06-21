Diagnsotics_UI <- tabPanel(title = "Diagnostics Waiting Times",  icon = icon("microscope"),
                            
                            
                            sidebarLayout(
                              sidebarPanel(width = 2,
                                           radioGroupButtons("diagnostics_dashboard_select",
                                                             choices = diagnostics_dashboard_list, status = "primary",
                                                             direction = "vertical", justified = T)),
                              mainPanel(width = 10
                                        
                                        
                                        
                              )))