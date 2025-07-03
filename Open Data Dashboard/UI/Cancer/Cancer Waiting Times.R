source("UI/Cancer/Cancer UI Waiting Times Sourcing Files/Landing Page.R")
source("UI/Cancer/Cancer UI Waiting Times Sourcing Files/31 Days Overview.R")
source("UI/Cancer/Cancer UI Waiting Times Sourcing Files/62 Days Overview.R")
source("UI/Cancer/Cancer UI Waiting Times Sourcing Files/Download Page.R")





Cancer_Waiting_List <- tabPanel(title = "Cancer Waiting Times",  icon = icon("microscope"),

                                
                                
                                sidebarLayout(
                                  sidebarPanel(width = 2,
                                               radioGroupButtons("cancer_waiting_time_select",
                                                                 choices = cancer_waiting_times, status = "primary",
                                                                 direction = "vertical", justified = T)),
                                  mainPanel(width = 10,
                                            
                                  Cancer_Waiting_Time_Land_Page_Code, ### End of conditional Panel
                                  Cancer_Waiting_Time_31_Days_Code, ### End of conditional panel
                                  Cancer_Waiting_Time_62_Days_Code, ### End of conditional Panel
                                  Cancer_Waiting_Times_Download_Page #end of conditional panel
                                            
                                            
                                  ))) #End of TabPanel