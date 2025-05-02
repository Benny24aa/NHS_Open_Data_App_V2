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




output$hb_cancer_outlier <- renderPlotly({
  Cancer_Scatter_Data <-  Cancer_Scatter_Data %>% 
    select(-CancerSiteICD10Code) %>% 
    filter(GeoName != "All Scotland Data") %>% 
    filter(CancerSite == input$Cancer_Type_Input_Stats) %>% 
  filter(GeoName %in% input$hb_name) %>% 
    filter(Sex == input$Cancer_Gender_Input)
  
  
  Cancer_Scatter_Data <- Cancer_Scatter_Data %>% 
    plot_ly(x = ~ AllAges,
            y = ~ DeathsAllAges,
            color = ~ GeoName,
            hoverinfo="text" ) %>% 
    layout(xaxis = list(title = "All Ages"),
           yaxis = list(title = "All Deaths"))
  
})

output$hb_cancer_outlier_box <-  renderPlotly({
  Cancer_Scatter_Data <-  Cancer_Scatter_Data %>% 
    select(-CancerSiteICD10Code) %>% 
    filter(GeoName != "All Scotland Data") %>% 
    filter(CancerSite == input$Cancer_Type_Input_Stats) %>% 
    filter(GeoName %in% input$hb_name) %>% 
    filter(Sex == input$Cancer_Gender_Input) %>% 
  plot_ly(x = ~GeoName,
          y = ~DeathsAllAges,
          color = ~ GeoName,
          type = "box",
          quartilemethod="inclusive")%>% 
    layout(xaxis = list(title = "All Ages"),
           yaxis = list(title = "All Deaths"))
  
})