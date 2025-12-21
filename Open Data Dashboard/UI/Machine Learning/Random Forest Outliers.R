source("UI/Machine Learning/Sub UI's/Outliers Page.R")

Random_Forest_UI <- tabPanel(
  title = "Random Forest - Anomaly Detection",
  icon  = icon("tree"),
  value = "ml_random_anomaly",
  
  
    # Header (stays outside the blue box)
    fluidRow(
      column(6,
             h2("Machine Learning - Prescribing and Dispensing Random Forest Outlier Detction", style = "color: #336699; font-weight: 600"))
    ),
    
    h4("Placeholder"),
  
    fluidRow(
      column(4, selectInput("AI_Model_Healthboard", "Select Health Board", 
                                                        choices = unique(WeeklyAE_Healthboard$HBName))),
      
      column(4,selectInput("AI_Model_Type", "Select Model Type", 
                                                        choices = c(
                                                          "Impurity"               = "impurity",
                                                          "Impurity (Corrected)"   = "impurity_corrected",
                                                          "Permutation Importance" = "permutation"
                                                        ))),
      
      column(4, selectInput("AI_Model_Trees", "Select Number of Trees", 
                                                        choices = c(
                                                          "5 trees"               = 5,
                                                          "10 trees"     = 10,
                                                          "20 trees"   = 20,
                                                          "50 trees"   = 50,
                                                          "100 trees"   = 100
                                                        ))),
      
    ),
    
    
  
  br(),
  actionButton("run_anomaly", "Run anomaly detection"),
 
  conditionalPanel(
    condition = "output.anomaly_ready == true",
   br(),
    br(),
    radioGroupButtons(
      inputId = "machine_model_select_id",
      choices = random_forest_list,
      status = "primary",
      direction = "horizontal",
      justified = TRUE,
      size = "lg" 
    ),
    br(),
  Random_Forest_Outlier_UI)
                        
                        
) #End of TabPanel

# c("none", "impurity", "impurity_corrected", "permutation")