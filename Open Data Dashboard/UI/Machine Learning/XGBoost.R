XGBoost_UI <- tabPanel(title = "XGBoost", 
                                      icon = icon("rocket"),

                       
                       # Header (stays outside the blue box)
fluidRow(
column(8, h2("Accident and Emergency XGBoost Modelling - Beta Stage", style = "color: #336699; font-weight: 600"))
                       ),          
                             

fluidRow(
  column(3, selectInput("AI_Model_XGBoost_Healthboard", "Select Health Board", 
                        choices = unique(WeeklyAE_Healthboard$HBName))),
  
  
  column(3,selectInput("AI_Model_XGBoost_Diseases", "Include Diseases in model", 
                       choices = c(
                         
                         "Remove Disease Data"    = "Disease_No",
                         "Include Disease Data"   = "Disease_Yes"
                       ))),
  
  column(3, selectInput("AI_Model_XGBoost_Trees", "Select Number of Runs", 
                        choices = c(
                          "500 trees"               = 500,
                          "1000 trees"     = 1000,
                          "2000 trees"   = 2000,
                          "5000 trees"   = 5000,
                          "10000 trees"   = 10000
                        ))),
  
  column(3, selectInput("AI_Model_XGBoost_Hospital", "Select Hospital", 
                        choices = unique(accident_emergency_xgboost_model$HospitalName))),
  
  fluidRow(
    column(12,
           plotlyOutput("XGBoost_Attendance_Plot", height = "600px")
    )
  )
  
)         
                                      
) #End of TabPanel


 
  
  