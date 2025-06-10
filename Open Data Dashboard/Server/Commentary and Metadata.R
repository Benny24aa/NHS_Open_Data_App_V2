output$cancer_mortality_metadata_table <- renderTable(Cancer_Metadata_Mortality)
output$cancer_mortality_metadata_table <- renderDataTable(Cancer_Metadata_Mortality)
output$cancer_incidence_metadata_table <- renderTable(Cancer_Metadata_Incidence)
output$cancer_incidence_metadata_table <- renderDataTable(Cancer_Metadata_Incidence)


output$cancer_31day_metadata_table <- renderTable(Cancer_31day_Metadata)
output$cancer_31day_metadata_table <- renderDataTable(Cancer_31day_Metadata)
output$cancer_62day_metadata_table <- renderTable(Cancer_62day_Metadata)
output$cancer_62day_metadata_table <- renderDataTable(Cancer_62day_Metadata)