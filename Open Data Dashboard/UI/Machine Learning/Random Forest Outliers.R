
Random_Forest_Outliers_UI <- tabPanel(
  title = "Random Forest - Anomaly Detection",
  icon  = icon("tree"),
  value = "ml_random_anomaly",
  
  actionButton("run_anomaly", "Run anomaly detection"),
  tableOutput("anomaly_table")
                        
                        
) #End of TabPanel