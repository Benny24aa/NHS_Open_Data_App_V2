#################################
source("UI/Information UI.R"
)# Sourcing in Information Tab from different script
source("UI/Reference File Download.R")
source("UI/Cancer Data Download.R")
source("UI/Mortality and Incidence UI.R")
source("UI/Mortality and Incidence Health Board Comparison.R")
#################################
navbarPage(title = div(tags$a(img(src="", width=120, alt = ""),
                              href= "",
                              target = "_blank"),
                       style = "position: relative; top: -10px;"),
           windowTitle = "Cancer Dashboard Application", #title for browser tab
           header = tags$head(includeCSS("www/styles.css"), # CSS styles
                              HTML("<html lang='en'>")),
           
           ##### Tab Panels
           information, ### basic information/home page
           Cancer_Mortality_Incidence,
           Cancer_Mortality_Incidence_Comparison,
           navbarMenu("Download Data", reference_file_download, cancer_data_download)

           
           
           
           
           
           
           
)#End of navbarpage