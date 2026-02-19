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
            
             uiOutput("ai_model_gp_cluster_filter")
           
      
    ),
    
    br(),
    uiOutput("RFModelBoxes"),
    
  ),
  
  div(
    style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
    
    fluidRow(
      column(12,
             plotlyOutput("predicted_vs_paid_plot", height = "600px")
      )
    ),
    
    uiOutput("model_last_fresh_date_outlier_1")
  ),
  
  br(),
  div(
    style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
  fluidRow(
    column(12,
           DT::DTOutput("predicted_vs_paid_table")
    )
  ),

  uiOutput("model_last_fresh_date_outlier_2")
)
  
  
)