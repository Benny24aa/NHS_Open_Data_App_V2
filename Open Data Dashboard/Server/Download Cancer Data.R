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
    selected_rows <- input$data_download_cancer_table_filtered_rows_all
    
    # Use filtered rows if available, or default to all data
    data_to_write <- data_download_table_cancer()
    if (!is.null(selected_rows)) {
      data_to_write <- data_to_write[selected_rows, ]
    }
    

    colnames(data_to_write) <- gsub("_", " ", colnames(data_to_write))
    
    write_csv(data_to_write, file)
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
    selected_rows <- input$data_download_cancer_waiting_list_table_filtered_rows_all
    
    if (is.null(selected_rows)) {
      # No filters were applied → download the full dataset
      write_csv(data_download_table_cancer_waiting_list(), file)
    } else {
      # User filtered table → download only filtered rows
      write_csv(data_download_table_cancer_waiting_list()[selected_rows, ], file)
    }
  }
)