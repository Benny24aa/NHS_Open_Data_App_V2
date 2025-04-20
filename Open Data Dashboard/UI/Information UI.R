information <- tabPanel(title = "Home", 
                        icon = icon("home"),
                        
                        fluidRow(
                          column(6,
                                 h2("Welcome to the Scottish Open Data Cancer Dashboard", style = "color:  #336699 ; font-weight: 600"))),
                        
                        fluidRow(
                          column(6, actionButton("new_next", tags$b("New content and future updates"),
                                                 icon = icon('calendar-alt')))),
                        
                        fluidRow(
                          column(12,
                                 h4(tags$b("?" , style = "color:  #336699 ; font-weight: 600")),
                                 p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/Scotland-Cancer-RShiny-Dashboard", icon("github"),
                                                                                                                                                                                                                  "", target="_blank"), ), 
                                 h4(tags$b("?", style = "color:  #336699 ; font-weight: 600" )),
                                 p(""),
                                 h4(tags$b(" Disclosure and Data Security Statement", style = "color:  #336699 ; font-weight: 600")),
                                 p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information.")),
                        )#End of Fluid Row
                        
) #End of TabPanel