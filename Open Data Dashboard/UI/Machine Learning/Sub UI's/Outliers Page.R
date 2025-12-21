Random_Forest_Outlier_UI  <- conditionalPanel(
  condition= 'input.machine_model_select_id == "Outlier_Tab_RF"', 
  
  div(
    style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
    fluidRow(column(3,div(class = "custom-select", selectInput("AI_Model_Month", "Select Month of 2025", 
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
    
    
  ),
  
  # actionButton("run_anomaly", "Run anomaly detection"),
  plotlyOutput("predicted_vs_paid_plot")
  
  
)