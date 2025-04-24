output$scotland_info_graph_server <- renderPlotly({
    Cancer_Full_Data <- Cancer_Full_Data %>% 
    select(-CancerSiteICD10Code) %>% 
      filter(CancerSite == input$Cancer_Type_Input) %>% 
    filter(Sex == "All") %>% 
    select(Year, AllAges, CrudeRate, EASR, WASR, StandardisedRatio, HBName, DataType) %>%
    filter(HBName %in% input$hb_name) %>% select(-HBName) %>% 
    filter(DataType == input$datatype_input)
    
    tooltip_1 <- c(paste0("Health Board: ", input$hb_name,  "<br>", "Data Type: ", input$datatype_input, "<br>",  "Measure Type: ", input$graphtype_input, "<br>", "Date: ", Cancer_Full_Data$Year, "<br>", "Total (All Ages): ", Cancer_Full_Data$AllAges,  "<br>",  "Crude Rate: ", round(Cancer_Full_Data$CrudeRate,2 ),  "<br>", "EASR: ", round(Cancer_Full_Data$EASR,2 ),  "<br>", "WASR: ", round(Cancer_Full_Data$WASR,2),  "<br>", "Standardised Ratio: ", round(Cancer_Full_Data$StandardisedRatio,2)))
    
    Cancer_Full_Data <- Cancer_Full_Data %>% 
      plot_ly(x = ~ Year,
              y = ~ get(input$graphtype_input),
              type = 'scatter',
              mode = 'lines',
              text=tooltip_1, 
              hoverinfo="text") %>% 
      layout(xaxis = list(title = "Year"),
             yaxis = list(title = input$graphtype_input))
   
})

output$scotland_gender_graph_server <- renderPlotly({
  Cancer_Full_Data <- Cancer_Full_Data %>% 
    select(-CancerSiteICD10Code) %>% 
    filter(CancerSite == input$Cancer_Type_Input) %>% 
    filter(Sex != "All") %>% 
    select(Year, Sex, AllAges, CrudeRate, EASR, WASR, StandardisedRatio, HBName, DataType) %>% 
    filter(HBName  %in% input$hb_name) %>% select(-HBName) %>% 
    filter(DataType == input$datatype_input)
  
  
  tooltip_1 <- c(paste0("Health Board: ", input$hb_name,  "<br>", "Data Type: ", input$datatype_input, "<br>",  "Measure Type: ", input$graphtype_input, "<br>", "Date: ", Cancer_Full_Data$Year, "<br>", "Gender: ", Cancer_Full_Data$Sex, "<br>", "Total (All Ages): ", Cancer_Full_Data$AllAges,  "<br>",  "Crude Rate: ", round(Cancer_Full_Data$CrudeRate,2 ),  "<br>", "EASR: ", round(Cancer_Full_Data$EASR,2 ),  "<br>", "WASR: ", round(Cancer_Full_Data$WASR,2),  "<br>", "Standardised Ratio: ", round(Cancer_Full_Data$StandardisedRatio,2)))
  
  Cancer_Full_Data <- Cancer_Full_Data %>% 
    plot_ly(x = ~ Year,
            y = ~ get(input$graphtype_input),
            color = ~ Sex, colors = gender_palette,
            type = 'scatter',
            mode = 'lines',
            text=tooltip_1, 
            hoverinfo="text") %>% 
    layout(xaxis = list(title = "Year"),
           yaxis = list(title = input$graphtype_input))
  
})




output$hb_compare_graph <- renderPlotly({
  Cancer_Full_Data <- Cancer_Full_Data %>% 
    select(-CancerSiteICD10Code) %>% 
    filter(Sex == "All") %>% 
    select(Year, AllAges, CrudeRate, EASR, WASR, StandardisedRatio, HBName, DataType, CancerSite) %>% 
    filter(DataType == input$datatype_input_compare) %>% 
    filter(HBName != "All Scotland Data") %>% 
    filter(CancerSite == input$Cancer_Type_Input_compare) %>% 
    # filter(HBName == input$hb_name_compare) %>% 
    plot_ly(x = ~ Year,
            y = ~ get(input$graphtype_input_compare),
            color = ~ HBName,
            type = 'scatter',
            mode = 'lines') %>% 
    layout(xaxis = list(title = "Year"),
           yaxis = list(title = input$graphtype_input_compare))
  
})

