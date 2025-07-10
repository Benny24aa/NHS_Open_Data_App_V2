CurrentAEUI <- tabPanel(title = "Most Recent Accident and Emergency Statistics", 
                       icon = icon("car-on"),
                       

                       
                       fluidRow(
                         
                         column(3, selectInput("HBName_Current_AE", "Select Health Board", choices = unique(WeeklyAE_Healthboard$HBName))),
                         
                         
                         column(3,  selectInput("AttendanceCategory_Current_AE", "Select Category", choices = unique(WeeklyAE_Healthboard$AttendanceCategory)))
                       
                         
                       ),
                       
                       fluidRow(
                         column(2, valueBoxOutput("attendancesBox")),
                         column(2, valueBoxOutput("over4Box")),
                         column(2, valueBoxOutput("over8Box")),
                         column(2, valueBoxOutput("over12Box")),
                         column(2, valueBoxOutput("within4Box"))
                       )
                       
                       
)