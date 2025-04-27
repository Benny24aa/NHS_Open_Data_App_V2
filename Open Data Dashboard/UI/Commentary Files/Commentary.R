Commentary <- tabPanel(title = "Commentary and Updates", 
                       
                       
                       sidebarLayout(
                         sidebarPanel(width = 3,
                                      radioGroupButtons("com_select",
                                                        choices = com_list, status = "primary",
                                                        direction = "vertical", justified = T)),
                         mainPanel(width = 9,
                                   
                                   
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "Cancer"',
                                     p(h3("27/04/2025")),
                                     h4("Cancer Healthboard Section "),
                                     tags$ul(
                                       tags$li(""),
                                       tags$li(""),
                                       tags$li(""))
                                   ), #end of conditional panel
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "WaitList"',
                                     p(h3("27/04/2025")),
                                     h4("Waiting List Healthboard Section "),
                                     tags$ul(
                                       tags$li(""))
                                   ) # end of conditional panel
                                   
                                   
                         ))) #End of TabPanel