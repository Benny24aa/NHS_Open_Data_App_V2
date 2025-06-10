information <- tabPanel(title = "Home", 
         icon = icon("home"),
         fluidRow(
           column(6,
                  h2("Welcome to the NHS Open Data Dashboard", style = "color:  #336699 ; font-weight: 600"))),
          
         fluidRow(
           column(6, actionButton("new_next", tags$b("New content and future updates"),
                                  icon = icon('calendar-alt')))),
         
         fluidRow(
           column(12,
                  h4(tags$b("What is the NHS Open Data Dashboard?" , style = "color:  #336699 ; font-weight: 600")),
                  p("The NHS Open Data Dashboard for Scotland is intended to educate and inform members of the public about health related issues across the entirety of Scotland.
                    We use open datasets from the NHS Open Data Website and turn them into visuals and aids which will help interested parties understand key points surrounding healthcare and health statistics. 
                    The dashboard rshiny code will be completely open sourced and the github link is provided at the top of the navigation bar. This is to allow interested parties (mainly aimed at recent graduates) to understand how such applications are built.
                    The code will be updated regularly and commentated on throughout the development of the application. If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/NHS_Open_Data_App_V2", icon("github"),
                                                                                                                                                                                                                 "", target="_blank"), ), 
                  h4(tags$b("Type of Data Explored?", style = "color:  #336699 ; font-weight: 600" )),
                  p("The dashboard will focus mainly on Healthboard, Council Areas, SIMD Deprivation Quinites and Deciles, Gender, and Age break downs across Scotland. The dashboard will have multiple sections which address different health related statitsics. 
                    Statistics such as and not limited to Cancelled Planned Operations, Delayed Discharges, A&E waiting times, Prescribed and Dispensed Data, and more. We aim to have a section for most of the categories that appear on the NHS opendata website.
                    An update on which sections have been added or will be added in the near future can be found at the top of the information section by clicking the 'New content and future updates' button."),
                  h4(tags$b(" Disclosure and Data Security Statement", style = "color:  #336699 ; font-weight: 600")),
                  p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information.")),
         )#End of Fluid Row
         
) #End of TabPanel

