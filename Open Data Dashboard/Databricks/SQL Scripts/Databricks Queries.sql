
##### Querying Main Models

  model_table <- reactive({
    if (input$AI_Model_Version == "Alpha_Model") {
      "nhs_waiting_times_dashboard.default.Random_Forest_Final"
    } else {
      "nhs_waiting_times_dashboard.default.Random_Forest_Beta"
    }
  })


SELECT 
        PaidDateMonth,
        HB,
        HBName,
        NumberOfPaidItems,
        Predicted,
        Outlier,
        Importance,
        Number_of_trees,
        GPCluster,
        MonthNum,
        PrescriberLocation,
        DispenserLocation
         FROM {model_table()}
      WHERE Importance = '{input$AI_Model_Type}'
        AND Number_of_trees = {input$AI_Model_Trees}
        AND HBName = '{input$AI_Model_Healthboard}'
        
#### Querying Table Related Dates

model_table_query <- reactive({

    glue("
   SELECT last_altered
   FROM nhs_open_data_ai.default.random_forest_refresh_dates
   WHERE table_name = '{model_table()}'
  ")
  })