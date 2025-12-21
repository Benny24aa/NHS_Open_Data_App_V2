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

##### Cancer UI's #####

## Mortality and Incidence
source("UI/Cancer/Cancer UI Setup.R")
source("UI/Cancer/Cancer Waiting Times.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Landing Page.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Healthboard Overview.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Cancer Download Page.R")
source("UI/Cancer/Cancer UI Setup Sourcing Files/Cancer_Statistics.R")

## Cancer Waiting Times 

source("UI/Cancer/Cancer UI Waiting Times Sourcing Files/Landing Page.R")
source("UI/Cancer/Cancer UI Waiting Times Sourcing Files/31 Days Overview.R")
source("UI/Cancer/Cancer UI Waiting Times Sourcing Files/62 Days Overview.R")
source("UI/Cancer/Cancer UI Waiting Times Sourcing Files/Download Page.R")

#### Diagnostics UI's ####
source("UI/Diagnostics/Diagnostics UI.R")
source("UI/Diagnostics/Landing Page.R")
source("UI/Diagnostics/Healthboard Overview.R")
source("UI/Diagnostics/Download Page.R")
source("UI/A&E/WeeklyAE_UI.R")
source("UI/A&E/A&E Current Week.R")
source("UI/A&E/A&E Current Week Sub Scripts/AE Interactive Map.R")

#### Machine Learning UI ###

source("UI/Machine Learning/Random Forest Outliers.R")
source("UI/Machine Learning/XGBoost.R")

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
           navbarMenu("A&E Waiting Times", icon = icon("hospital"), CurrentAEUI, WeeklyAEUI, AE_Interactive_Map ),
           navbarMenu("Cancer", icon = icon("disease"), Cancer_UI_Setup, Cancer_Waiting_List),
           Diagnsotics_UI,
           navbarMenu("Machine Learning", icon = icon("brain"), Random_Forest_UI, XGBoost_UI),
           reference_file_download,
           navbarMenu("Contact and Feedback", icon = icon("envelope"),Feedback,Report_Bug )
           ##### more soon

   


          
           

           
           
           
           
           
           
           
           
)#End of navbarpage