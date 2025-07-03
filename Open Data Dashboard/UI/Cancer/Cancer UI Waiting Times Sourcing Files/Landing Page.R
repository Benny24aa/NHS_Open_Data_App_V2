Cancer_Waiting_Time_Land_Page_Code <- conditionalPanel(
  condition= 'input.cancer_waiting_time_select == "Cancer_Waiting_Time_Page"',
  
  fluidRow(
    column(6,
           h2("Scottish Cancer Waiting Times Landing Page", style = "color:  #336699 ; font-weight: 600"))),
  
  fluidRow(
    column(6, actionButton("new_next", tags$b("New content and future updates"),
                           icon = icon('calendar-alt')))),
  
  fluidRow(
    column(12,
           h4(tags$b("Background Information", style = "color:  #336699 ; font-weight: 600" )),
           p("Cancer Waiting Times statistics for the 62-day standard for patients urgently referred with a suspicion of cancer to first cancer treatment and for the 31-day standard for patients regardless of the route of referral from date decision to treat to first cancer treatment. Includes data presented by NHS Board and Cancer Type."),
           
           
           h4(tags$b("Open Source Code Information" , style = "color:  #336699 ; font-weight: 600")),
           p("This GitHub repository hosts the full source code for an interactive dashboard that visualizes Cancer Waiting Times (CWT) statistics in Scotland, as reported by NHS Scotland and Public Health Scotland."),
           p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/NHS_Open_Data_App_V2", icon("github"),
                                                                                                       "", target="_blank"), ), 
           
           h4(tags$b(" Disclosure, Data Security Statement and Disclaimer", style = "color:  #336699 ; font-weight: 600")),
           p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information. This means that this RShiny open data application is an independent project and is not affiliated with, endorsed by, or representative of the National Health Service (NHS) or any of its associated organizations. The NHS is mentioned solely because the data used in this application originates from publicly available NHS open data sources. ")),
  )#End of Fluid Row
)