
Random_Forest_Outliers_UI <- tabPanel(
  title = "Random Forest - Anomaly Detection",
  icon  = icon("tree"),
  value = "ml_random_anomaly",
  
  div(
    style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
    fluidRow(
      column(3,div(class = "custom-select", selectInput("AI_Model_Healthboard", "Select Health Board", 
                                                        choices = unique(WeeklyAE_Healthboard$HBName)))),
      
      column(3,div(class = "custom-select", selectInput("AI_Model_Type", "Select Model Type", 
                                                        choices = c(
                                                          "Impurity"               = "impurity",
                                                          "Impurity (Corrected)"   = "impurity_corrected",
                                                          "Permutation Importance" = "permutation"
                                                        )))),
      
      column(3,div(class = "custom-select", selectInput("AI_Model_Trees", "Select Number of Trees", 
                                                        choices = c(
                                                          "5 trees"               = 5,
                                                          "10 trees"     = 10,
                                                          "20 trees"   = 20,
                                                          "50 trees"   = 50,
                                                          "100 trees"   = 100
                                                        )))),
      
      column(3,div(class = "custom-select", selectInput("AI_Model_Month", "Select Month of 2025", 
                                                        choices = c(
                                                          "January 2025"               = 1,
                                                          "Feburary 2025"     = 2,
                                                          "March 2025"   = 3,
                                                          "April 2025"   = 4,
                                                          "May 2025"   = 5, 
                                                          "June 2025"               = 6,
                                                          "July 2025"     = 7,
                                                          "August 2025"   = 8,
                                                          "September 2025"   = 9
                                                        )))),
      
    ),
    
    actionButton("run_anomaly", "Run anomaly detection")
    
    ),
  
  # actionButton("run_anomaly", "Run anomaly detection"),
 plotlyOutput("predicted_vs_paid_plot")
                        
                        
) #End of TabPanel

# c("none", "impurity", "impurity_corrected", "permutation")