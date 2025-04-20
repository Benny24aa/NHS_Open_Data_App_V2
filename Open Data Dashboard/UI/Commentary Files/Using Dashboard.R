DashboardUse <- tabPanel(title = "How to use the Dashboard", 
                       
                       
                         mainPanel(
                           tagList(h3(tags$b("Using the dashboard")),
                                   p("There are tabs across the top for the each topic area within the dashboard - these are all related to NHS open data sources across different health issues and topics.
                                   The Further information tab provides relevant updates for each of the sections, for example if any new data has been added or there is any new updates to the dashboard, a road map which 
                                     gives information regarding future potential updates, and also information on how to use the dashboard."), br(),
                                   
                                   p(tags$b("Interacting with the dashboard")),
                                   p(tags$li("On each tab there are menu boxes that allow the user to select the level of data they wish to see - these are healthboards level, hospital level, data zone level and more.")), 
                                   p(tags$li("On the line charts,
                                           clicking on a category in the legend will remove it from the chart. This is useful to reduce the number of lines
                                           on the chart and makes them easier to see. A further click on the categories will add them back into the chart.")),
                                   br(),
                                   
                                   p(tags$b("Downloading data")),
                                   p(tags$li("There is the option to download data as a csv file on the Download Data tabs on each section of the dashboard.")),
                                   p(tags$li("Some of the data is also available on the ",
                                             tags$a(href="https://www.opendata.nhs.scot/",
                                                    "NHS Open Data Website", target="_blank")))
                           ) #tagList
                                   
                                
                                     
                                   ) 
                                   
                         ) #End of TabPanel


