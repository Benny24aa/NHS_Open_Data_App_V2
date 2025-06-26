data_download_table_diagnostics <- reactive({
  
  table_data_diagnostics <- switch(input$diagnostics_download_select,
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

output$download_table_diagnostics_csv <- downloadHandler(
  filename = function() {
    paste(input$diagnostics_download_select, "_data.csv", sep = "")
  },
  content = function(file) {
    selected_rows <- input$data_download_diagnostics_table_filtered_rows_all
    
    data_to_write <- data_download_table_diagnostics()
    
    # Use filtered rows if available
    if (!is.null(selected_rows)) {
      data_to_write <- data_to_write[selected_rows, ]
    }
    
    # Clean Names
    colnames(data_to_write) <- gsub("_", " ", colnames(data_to_write))
    
    write_csv(data_to_write, file)
  }
)