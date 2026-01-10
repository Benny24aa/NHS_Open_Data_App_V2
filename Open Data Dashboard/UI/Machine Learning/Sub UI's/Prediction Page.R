Random_Forest_Prediction_UI  <- conditionalPanel(
  condition= 'input.machine_model_select_id == "Predition_Tab_RF"', 
  
  div(
    style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
    fluidRow( uiOutput("ai_model_gp_cluster_filter_prediction")
             
             
    ),
    
    
  ),
  br(),
  
  div(
    style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
    
    fluidRow(
      column(12,
             plotlyOutput("actual_against_predicted_plot", height = "600px")
      )
    )
  ))