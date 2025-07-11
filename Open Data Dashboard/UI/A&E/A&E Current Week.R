CurrentAEUI <- tabPanel(title = "Most Recent Accident and Emergency Statistics", 
                       icon = icon("car-on"),
                       
                       fluidRow(
                         column(6,
                                h2("Most Recent Accident and Emergency Statistics", style = "color:  #336699 ; font-weight: 600"))),
                       h4("Coming Soon"),
                       

                       
                       fluidRow(
                         
                         column(3, selectInput("HBName_Current_AE", "Select Health Board", choices = unique(WeeklyAE_Healthboard$HBName))),
                         
                         
                         column(3,  selectInput("AttendanceCategory_Current_AE", "Select Category", choices = unique(WeeklyAE_Healthboard$AttendanceCategory)))
                       
                         
                       ), 
                       uiOutput("currentAEBoxes")
                       
                       
                       
)