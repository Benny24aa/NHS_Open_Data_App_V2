Cancer_Landing_Page <- conditionalPanel(
  condition= 'input.cancer_dashboard_select == "Cancer_Landing_Page"',
  
  fluidRow(
    column(6,
           h2("Cancer Incidence and Mortality Landing Page", style = "color:  #336699 ; font-weight: 600"))),
  
  fluidRow(
    column(6, actionButton("new_next", tags$b("New content and future updates"),
                           icon = icon('calendar-alt')))),
  
  fluidRow(
    column(12,
           
           h4(tags$b("Background Information", style = "color:  #336699 ; font-weight: 600" )),
           p("This dashboard shows annual data of new cancer incidence cases and deaths from cancer in Scotland. Data is presented by Health Boards within Scotland, the figures are further broken down by age group and sex.
The cancer sites reported on include: bladder, bone and connective tissue, brain and central nervous system, breast colorectal, female genital organs, head and neck, hodgkin lymphoma, kidney, leukaemias, liver, lung and mesothelioma, male genital organs, multiple myeloma, non-hodgkin lymphoma, oesophageal, pancreatic, skin, stomach."),
           
           h4(tags$b("Open Source Code Information" , style = "color:  #336699 ; font-weight: 600")),
           p("This GitHub repository contains the complete source code for an interactive web dashboard designed to visualize cancer incidence and mortality statistics across Healthboard."),
           
           p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/NHS_Open_Data_App_V2", icon("github"),
                                                                                                       "", target="_blank"), ), 
           h4(tags$b(" Disclosure, Data Security Statement and Disclaimer", style = "color:  #336699 ; font-weight: 600")),
           p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information. This means that this RShiny open data application is an independent project and is not affiliated with, endorsed by, or representative of the National Health Service (NHS) or any of its associated organizations. The NHS is mentioned solely because the data used in this application originates from publicly available NHS open data sources. ")),
  )#End of Fluid Row
)