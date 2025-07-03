source("UI/Cancer/Cancer UI Setup Sourcing Files/Landing Page.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Healthboard Overview.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Healthboard Comparison.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Cancer Download Page.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Cancer_Statistics.R")

Cancer_UI_Setup <- tabPanel(title = "Mortality and Incidence",  icon = icon("disease"),
                       
                       
                       sidebarLayout(
                         sidebarPanel(width = 2,
                                      radioGroupButtons("cancer_dashboard_select",
                                                        choices = cancer_dashboards, status = "primary",
                                                        direction = "vertical", justified = T)),
                         mainPanel(width = 10,
                                   Cancer_Landing_Page, #end of conditional panel
                                   Cancer_Overview, # end of conditional panel
                                   Cancer_Compare, #end of conditional panel
                                   Cancer_Download,#end of conditional panel
                                   Cancer_Statistics #end of conditional panel
))) #End of TabPanel