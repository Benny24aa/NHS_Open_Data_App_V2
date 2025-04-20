#################################
source("UI/Information UI.R")
source("UI/Cancer/Cancer Information UI.R"
)# Sourcing in Information Tab from different script
source("UI/Reference File Download.R")
source("UI/Cancer/Cancer Data Download.R")
source("UI/Cancer/Mortality and Incidence UI.R")
source("UI/Cancer/Mortality and Incidence Health Board Comparison.R")#
source("UI/Commentary Files/Roadmap.R")
source("UI/Commentary Files/Using Dashboard.R")

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
           navbarMenu("Dashboard Information", DashboardUse, Roadmap),
           navbarMenu("Cancer",cancer_information, Cancer_Mortality_Incidence, Cancer_Mortality_Incidence_Comparison, cancer_data_download),
           navbarMenu("Download Data", reference_file_download)

           
           
           
           
           
           
           
)#End of navbarpage