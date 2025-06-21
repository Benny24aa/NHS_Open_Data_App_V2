data_download_table_diagnostics <- reactive({
  
  table_data_diagnostics <- switch(input$diagnostics_download_select,
                              "diagnostics_waiting_times" = diagnostics_waiting_times,
                              "diagnostics_final_dataset_rates" = diagnostics_final_dataset_rates)
  

})

# Render Data Table

output$data_download_diagnostics_table_filtered <- DT::renderDataTable({
  
  # Remove the underscore from column names in the table
  table_colnames_diagnostics <-  gsub("_", " ", colnames(data_download_table_diagnostics()))
  
  DT::datatable(data_download_table_diagnostics(), style = 'bootstrap',
                class = 'table-bordered table-condensed',
                rownames = FALSE, 
                options = list(pageLength = 20,
                               dom = 'tip',
                               autoWidth = TRUE),
                filter = "top",
                colnames = table_colnames_diagnostics)
  
})

# Download Data 
output$download_table_diagnostics_csv <- downloadHandler(
  filename = function() {
    paste(input$diagnostics_download_select, "_data.csv", sep = "")
  },
  content = function(file) {
    # This downloads only the data the user has selected using the table filters
    write_csv(data_download_table_diagnostics()[input[["data_download_diagnostics_table_filtered"]], ], file) 
  } 
)

