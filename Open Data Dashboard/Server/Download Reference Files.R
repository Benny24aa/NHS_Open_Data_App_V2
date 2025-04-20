data_download_table <- reactive({
  
  table_data <- switch(input$download_select,
                       "HB_Lookup" = HB_Lookup,
                         "Council_Lookup" = Council_Lookup,
                         "Hospital_Lookup" = Hospital_Lookup,
                         "Interminate_Zone_Lookup" = Interminate_Zone_Lookup,
                         "Data_Zone_Lookup" = Data_Zone_Lookup)
  
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

# Download Data 
output$download_table_csv <- downloadHandler(
  filename = function() {
    paste(input$download_select, "_data.csv", sep = "")
  },
  content = function(file) {
    # This downloads only the data the user has selected using the table filters
    write_csv(data_download_table()[input[["download_data_table_filtered_rows_all"]], ], file) 
  } 
)