Cancer_UI_Setup <- tabPanel(title = "Cancer Dashboard", 
                       
                       
                       sidebarLayout(
                         sidebarPanel(width = 3,
                                      radioGroupButtons("cancer_dashboard_select",
                                                        choices = cancer_dashboards, status = "primary",
                                                        direction = "vertical", justified = T)),
                         mainPanel(width = 9,
                                   

                                   conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Landing_Page"',
                                   ), #end of conditional panel
                                   
                                   conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Overview"',
                                   ), # end of conditional panel
                                   
                                   conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Comparison"',
                                   ), #end of conditional panel
                                  
                                    conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Download_Data"',
                                   ) #end of conditional panel
                                   
                                   
                         ))) #End of TabPanel