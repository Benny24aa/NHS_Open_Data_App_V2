source("UI/Diagnostics/Landing Page.R")
source("UI/Diagnostics/Healthboard Overview.R")
source("UI/Diagnostics/Download Page.R")
source("UI/Diagnostics/Healthboard Comparison.R")



Diagnsotics_UI <- tabPanel(title = "Diagnostics Waiting Times",  icon = icon("microscope"),
                            
                            
                            sidebarLayout(
                              sidebarPanel(width = 2,
                                           radioGroupButtons("diagnostics_dashboard_select",
                                                             choices = diagnostics_dashboard_list, status = "primary",
                                                             direction = "vertical", justified = T)),
                              mainPanel(width = 10,
                                        
                                        
                                        Diagnostics_Landing_Page,#end of conditional panel
                                        Diagnostics_Healthboard_Overview, # end of conditional panel
                                        Diagnostics_Comparison_Page, # end of conditional panel
                                        Diagnostics_Download_Page #end of conditional panel
                                        

                              
                              )))