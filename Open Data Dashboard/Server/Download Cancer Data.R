data_download_table_cancer <- reactive({
  
  table_data_cancer <- switch(input$cancer_download_select,
                      "Cancer_Full_Data" = Cancer_Full_Data,
                      "Cancer_Scatter_Data" = Cancer_Scatter_Data)

  # Cancer_Full_Data <- Cancer_Full_Data %>% 
  #   filter(HBName == input$hb_name)
})

# Render Data Table

output$data_download_cancer_table_filtered <- DT::renderDataTable({
  
  # Remove the underscore from column names in the table
  table_colnames_cancer  <-  gsub("_", " ", colnames(data_download_table_cancer()))
  
  DT::datatable(data_download_table_cancer(), style = 'bootstrap',
                class = 'table-bordered table-condensed',
                rownames = FALSE, 
                options = list(pageLength = 20,
                               dom = 'tip',
                               autoWidth = TRUE),
                filter = "top",
                colnames = table_colnames_cancer)
  
})

# Download Data 
output$download_table_csv <- downloadHandler(
  filename = function() {
    paste(input$cancer_download_select, "_data.csv", sep = "")
  },
  content = function(file) {
    # This downloads only the data the user has selected using the table filters
    write_csv(data_download_table_cancer()[input[["download_data_cancer_table_filtered_rows_all"]], ], file) 
  } 
)





################## Cancer Waiting List download table

data_download_table_cancer_waiting_list <- reactive({
  
  table_data_cancer <- switch(input$cancer_waiting_list_download_select,
                              "Cancer_Waiting_Times_31_days_T" = Cancer_Waiting_Times_31_days_T,
                              "Cancer_Waiting_Times_62_days_T" = Cancer_Waiting_Times_62_days_T)
  
})

# Render Data Table

output$data_download_cancer_waiting_list_table_filtered <- DT::renderDataTable({
  
  # Remove the underscore from column names in the table
  table_colnames_cancer_waiting_list  <-  gsub("_", " ", colnames(data_download_table_cancer_waiting_list()))
  
  DT::datatable(data_download_table_cancer_waiting_list(), style = 'bootstrap',
                class = 'table-bordered table-condensed',
                rownames = FALSE, 
                options = list(pageLength = 20,
                               dom = 'tip',
                               autoWidth = TRUE),
                filter = "top",
                colnames =  table_colnames_cancer_waiting_list)
  
})

# Download Data 
output$download_table_csv_waiting_list <- downloadHandler(
  filename = function() {
    paste(input$cancer_waiting_list_download_select, "_data.csv", sep = "")
  },
  content = function(file) {
    # This downloads only the data the user has selected using the table filters
    write_csv(data_download_table_cancer_waiting_list()[input[["download_data_cancer_waiting_list_table_filtered_rows_all"]], ], file) 
  } 
)