data_download_table <- reactive({
  
  table_data <- switch(input$download_select,
                       "HB_Lookup" = HB_Lookup,
                         "Council_Lookup" = Council_Lookup,
                         "Hospital_Lookup" = Hospital_Lookup,
                         "Interminate_Zone_Lookup" = Interminate_Zone_Lookup,
                         "Data_Zone_Lookup" = Data_Zone_Lookup,
                          "HB_Pop_Estimates" = HB_Pop_Estimates)
  
  
})

# Render Data Table

output$data_download_table_filtered <- DT::renderDataTable({
  
  # Remove the underscore from column names in the table
  table_colnames_2  <-  gsub("_", " ", colnames(data_download_table()))
  
  DT::datatable(data_download_table(), style = 'bootstrap',
                class = 'table-bordered table-condensed',
                rownames = FALSE, 
                options = list(pageLength = 20,
                               dom = 'tip',
                               autoWidth = TRUE),
                filter = "top",
                colnames = table_colnames_2)
  
})

output$download_table_csv_reference <- downloadHandler(
  filename = function() {
    paste(input$download_select, "_data.csv", sep = "")
  },
  content = function(file) {
    selected_rows <- input$data_download_table_filtered_rows_all
    
    # Get the dataset
    data_to_write <- data_download_table()
    
    # Use only selected rows if available
    if (!is.null(selected_rows)) {
      data_to_write <- data_to_write[selected_rows, ]
    }

    colnames(data_to_write) <- gsub("_", " ", colnames(data_to_write))
    
    # Write the data
    write_csv(data_to_write, file)
  }
)