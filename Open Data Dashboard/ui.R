#################################
source("UI/Information UI.R")
source("UI/Reference File Download.R")
source("UI/Commentary Files/Roadmap.R")
source("UI/Commentary Files/Using Dashboard.R")
source("UI/Commentary Files/Commentary.R")
source("UI/Cancer/Cancer UI Setup.R")

#################################
navbarPage(title = div(tags$a(img(src="", width=120, alt = ""),
                              href= "",
                              target = "_blank"),
                       style = "position: relative; top: -10px;"),
           windowTitle = "Cancer Dashboard Application", #title for browser tab
           header = tags$head(includeCSS("www/styles.css"), # CSS styles
                              HTML("<html lang='en'>")),
           
           ##### Tab Panels
           information,
           navbarMenu("Dashboard Information",icon = icon("info"), DashboardUse, Roadmap, Commentary),
           navbarMenu("Download Data",icon = icon("table"), reference_file_download),
           Cancer_UI_Setup

           
           
           
           
           
           
           
)#End of navbarpage