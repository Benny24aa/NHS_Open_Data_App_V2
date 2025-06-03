Commentary <- tabPanel(title = "Commentary", 
                       
                       
                       sidebarLayout(
                         sidebarPanel(width = 3,
                                      radioGroupButtons("com_select",
                                                        choices = com_list, status = "primary",
                                                        direction = "vertical", justified = T)),
                         mainPanel(width = 9,
                                   
                                   
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "Cancer_Mortality_Incidence_Section"',
                                     p(h3("27/04/2025")),
                                     h4("Cancer Mortality and Incidence Commentary "),
                                     tags$ul(
                                       tags$li(""),
                                       tags$li(""),
                                       tags$li(""))
                                   ), #end of conditional panel
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "Cancer_Waiting_List_Section"',
                                     p(h3("27/04/2025")),
                                     h4("Cancer Waiting List Commentary"),
                                     tags$ul(
                                       tags$li(""))
                                   ) # end of conditional panel
                                   
                                   
                         ))) #End of TabPanel