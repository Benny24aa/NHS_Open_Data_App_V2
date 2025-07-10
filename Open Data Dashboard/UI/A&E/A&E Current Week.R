CurrentAEUI <- tabPanel(title = "Most Recent Accident and Emergency Statistics", 
                       icon = icon("car-on"),
                       

                       
                       fluidRow(
                         
                         column(3, selectInput("HBName_Current_AE", "Select Health Board", choices = unique(WeeklyAE_Healthboard$HBName))),
                         
                         
                         column(3,  selectInput("AttendanceCategory_Current_AE", "Select Category", choices = unique(WeeklyAE_Healthboard$AttendanceCategory)))
                       
                         
                       ), 
                       uiOutput("currentAEBoxes")
                       
                       
                       
)