#################################

library(shinyjs)

useShinyjs()

##### Dashboard Information UI's
source("UI/Information UI.R")
source("UI/Reference File Download.R")
source("UI/Commentary Files/Roadmap.R")
source("UI/Commentary Files/Using Dashboard.R")
source("UI/Commentary Files/Commentary.R")

# Engagement with users UI
source("UI/feedback.R")
source("UI/report a bug.R")

# Cancer UI's
source("UI/Cancer/Cancer UI Setup.R")
source("UI/Cancer/Cancer Waiting Times.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Landing Page.R")
# Diagnostics UI
source("UI/Diagnostics/Diagnostics UI.R")
#################################
navbarPage(id = "maintabid",
            title = div(tags$a(img(src="", width=120, alt = ""),
                              href= "",
                              target = "_blank"),
                       style = "position: relative; top: -10px;"),
           windowTitle = "NHS Open Dashboard", #title for browser tab
           header = tags$head(includeCSS("www/styles.css"), # CSS styles
                              HTML("<html lang='en'>")),
           
           ##### Tab Panels
           information,
           navbarMenu("Dashboard Information",icon = icon("info"), DashboardUse, Roadmap, Commentary),
           navbarMenu("Cancer", icon = icon("disease"), Cancer_UI_Setup, Cancer_Waiting_List),
           Diagnsotics_UI,
           navbarMenu("A&E Waiting Times", icon = icon("hospital"), ),
           reference_file_download,
           navbarMenu("Contact and Feedback", icon = icon("envelope"),Feedback,Report_Bug )
           ##### more soon

   


          
           

           
           
           
           
           
           
           
           
)#End of navbarpage