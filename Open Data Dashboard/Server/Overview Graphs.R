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
    filter(DataType %in% input$datatype_input_compare) %>% 
    filter(HBName != "All Scotland Data") %>% 
    filter(CancerSite %in% input$Cancer_Type_Input_compare) %>% 
    filter(HBName %in% input$Healthboard_Input_compare)
  
  tooltip_1 <- c(paste0("Health Board: ", Cancer_Full_Data$HBName,  "<br>", "Data Type: ", input$datatype_input_compare, "<br>",  "Measure Type: ", input$graphtype_input_compare, "<br>", "Date: ", Cancer_Full_Data$Year, "<br>", "Total (All Ages): ", Cancer_Full_Data$AllAges,  "<br>",  "Crude Rate: ", round(Cancer_Full_Data$CrudeRate,2 ),  "<br>", "EASR: ", round(Cancer_Full_Data$EASR,2 ),  "<br>", "WASR: ", round(Cancer_Full_Data$WASR,2),  "<br>", "Standardised Ratio: ", round(Cancer_Full_Data$StandardisedRatio,2)))
  
  

  
  Cancer_Full_Data <- Cancer_Full_Data %>% 
    plot_ly(x = ~ Year,
            y = ~ get(input$graphtype_input_compare),
            color = ~ HBName,
            type = 'scatter',
            mode = 'lines',
            text=tooltip_1, 
            hoverinfo="text" ) %>% 
    layout(xaxis = list(title = "Year"),
           yaxis = list(title = input$graphtype_input_compare))
  
})




output$hb_cancer_outlier <- renderPlotly({
  Cancer_Scatter_Data <-  Cancer_Scatter_Data %>% 
    select(-CancerSiteICD10Code) %>% 
    filter(GeoName != "All Scotland Data") %>% 
    filter(CancerSite == input$Cancer_Type_Input_Stats) %>% 
  filter(GeoName %in% input$hb_name) %>% 
    filter(Sex == input$Cancer_Gender_Input)
  
  fit <- lm(DeathsAllAges ~ AllAges, data = Cancer_Scatter_Data)
  
  tooltip_1 <- c(paste0("Health Board: ", Cancer_Scatter_Data$GeoName, "<br>", "Date: ", Cancer_Scatter_Data$Year, "<br>", "Sex: ", Cancer_Scatter_Data$Sex, "<br>", "Cancer Site: ", Cancer_Scatter_Data$CancerSite, "<br>", "Incidence: ", Cancer_Scatter_Data$AllAges, "<br>", "Deaths: ", Cancer_Scatter_Data$DeathsAllAges))
  
  Cancer_Scatter_Data <- Cancer_Scatter_Data %>% 
    plot_ly(x = ~ AllAges,
            y = ~ DeathsAllAges,
            color = ~ GeoName,
            text=tooltip_1, 
            hoverinfo="text"  ) %>% 
    layout(xaxis = list(title = "All Ages"),
           yaxis = list(title = "All Deaths"))%>% 
    add_markers(y = ~DeathsAllAges) %>% 
    add_lines(x = ~AllAges, y = fitted(fit))%>%
    layout(showlegend = F)
  
})

output$hb_cancer_outlier_box <-  renderPlotly({
  Cancer_Scatter_Data <-  Cancer_Scatter_Data %>% 
    select(-CancerSiteICD10Code) %>% 
    filter(GeoName != "All Scotland Data") %>% 
    filter(CancerSite == input$Cancer_Type_Input_Stats) %>% 
    filter(GeoName %in% input$hb_name) %>% 
    filter(Sex == input$Cancer_Gender_Input) 
  

  Cancer_Scatter_Data <- Cancer_Scatter_Data %>% 
  plot_ly(x = ~GeoName,
          y = ~get(input$BoxPlot_Input_Cancer),
          color = ~ GeoName,
          type = "box",
          quartilemethod="inclusive" )%>% 
    layout(xaxis = list(title = "Health Board Name"),
           yaxis = list(title = input$BoxPlot_Input_Cancer))
  
})


########################
# Cancer Waiting Times #
########################

##### 31 days #####

output$cancer_waiting_list_overview_31_days <- renderPlotly({
  
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>% 
    select(-Health_Board_Patient_Treatment, -Percent_31_Days) %>%  ### Will only consider patients from initial Health Board before treatment for this graph
    filter(CancerType == input$Cancer_Type_Input_Waiting_Times_Select)
  
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>% 
    group_by(Health_Board_Patient, CancerType, Quarter) %>% 
    summarise(NumberOfEligibleReferrals31DayStandard = sum(NumberOfEligibleReferrals31DayStandard), .groups = 'drop') %>% 
    filter(Health_Board_Patient %in% input$hb_name_waiting_times)

  
  tooltip_1 <- c(paste0("Health Board: ", input$hb_name_waiting_times, "<br>", "Quarter: ", Cancer_Waiting_Times_31_days_T$Quarter, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select, "<br>", "Number Of Eligible Referrals 31 Day Standard : ", Cancer_Waiting_Times_31_days_T$NumberOfEligibleReferrals31DayStandard))
  
    
  
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>% 
    plot_ly(x = ~ Quarter,
            y = ~ NumberOfEligibleReferrals31DayStandard,
            type = 'scatter',
            mode = 'lines',
            text = tooltip_1,
            hoverinfo="text") %>% 
    layout(xaxis = list(title = "Quarter"),
           yaxis = list(title = "Referrals 31 Day Standard"))
    
    })


output$cancer_waiting_list_overview_31_days_treatmenthb <- renderPlotly({
  
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>% 
   select(-Percent_31_Days) %>%  ### Will only consider patients from initial Health Board before treatment for this graph
  filter(Quarter == input$Cancer_Quarter_Waiting_Times) %>% 
    filter(Health_Board_Patient %in% input$hb_name_waiting_times)  %>% 
    filter(CancerType == input$Cancer_Type_Input_Waiting_Times_Select)

  tooltip_1 <- c(paste0("Health Board: ", Cancer_Waiting_Times_31_days_T$Health_Board_Patient_Treatment, "<br>", "Quarter: ", input$Cancer_Quarter_Waiting_Times, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select, "<br>", "Number Of Eligible Referrals Treated Within 31Days : ", Cancer_Waiting_Times_31_days_T$NumberOfEligibleReferralsTreatedWithin31Days))
  
  
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>% 
    plot_ly(x = ~ Health_Board_Patient_Treatment,
            y = ~ NumberOfEligibleReferralsTreatedWithin31Days,
            color = ~ Health_Board_Patient_Treatment,
            type = 'bar',
            text = tooltip_1,
            hoverinfo="text") %>% 
    layout(xaxis = list(title = "Quarter"),
           yaxis = list(title = "Number of Patients Referred and Treated by a Healthboard in 31 days"))
  
})


output$cancer_waiting_list_overview_31_days_treatmenthb_compare <- renderPlotly({
  
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>% 
    select(-Percent_31_Days) %>%  ### Will only consider patients from initial Health Board before treatment for this graph
    filter(Health_Board_Patient %in% input$hb_name_waiting_times) %>% 
    filter(CancerType == input$Cancer_Type_Input_Waiting_Times_Select)
  
  tooltip_1 <- c(paste0("Health Board: ", Cancer_Waiting_Times_31_days_T$Health_Board_Patient_Treatment, "<br>", "Quarter: ", Cancer_Waiting_Times_31_days_T$Quarter, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select, "<br>", "Number Of Eligible Referrals Treated Within 31 Days : ", Cancer_Waiting_Times_31_days_T$NumberOfEligibleReferralsTreatedWithin31Days))
  
  
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>% 
    plot_ly(x = ~ Quarter,
            y = ~ NumberOfEligibleReferralsTreatedWithin31Days,
            color = ~ Health_Board_Patient_Treatment,
            type = 'scatter',
            mode = 'lines',
            text = tooltip_1,
            hoverinfo="text") %>% 
    layout(xaxis = list(title = "Quarter"),
           yaxis = list(title = "Number of Patients Referred and Treated by a Healthboard in 31 days"))
  
})




#################

### 62 days ####

################

output$cancer_waiting_list_overview_62_days <- renderPlotly({
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>% 
    select(-Health_Board_Patient_Treatment, -Percent_62_Days) %>%  ### Will only consider patients from initial Health Board before treatment for this graph
    filter(CancerType == input$Cancer_Type_Input_Waiting_Times_Select_62)
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>% 
    group_by(Health_Board_Patient, CancerType, Quarter) %>% 
    summarise(NumberOfEligibleReferrals62DayStandard = sum(NumberOfEligibleReferrals62DayStandard), .groups = 'drop') %>% 
    filter(Health_Board_Patient %in% input$hb_name_waiting_times)
  
  
  tooltip_1 <- c(paste0("Health Board: ", input$hb_name_waiting_times, "<br>", "Quarter: ", Cancer_Waiting_Times_62_days_T$Quarter, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select_62, "<br>", "Number Of Eligible Referrals 62 Day Standard : ", Cancer_Waiting_Times_62_days_T$NumberOfEligibleReferrals62DayStandard))
  
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>% 
    plot_ly(x = ~ Quarter,
            y = ~ NumberOfEligibleReferrals62DayStandard,
            type = 'scatter',
            mode = 'lines',
            text= tooltip_1,
            hoverinfo="text") %>% 
    layout(xaxis = list(title = "Quarter"),
           yaxis = list(title = "Referrals 62 Day Standard"))
  
})


output$cancer_waiting_list_overview_62_days_treatmenthb <- renderPlotly({
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>% 
    select(-Percent_62_Days) %>%  ### Will only consider patients from initial Health Board before treatment for this graph
    filter(CancerType == input$Cancer_Type_Input_Waiting_Times_Select_62) %>% 
    filter(Quarter == input$Cancer_Quarter_Waiting_Times_62) %>% 
    filter(Health_Board_Patient %in% input$hb_name_waiting_times) 
  
  tooltip_1 <- c(paste0("Health Board: ", Cancer_Waiting_Times_62_days_T$Health_Board_Patient_Treatment, "<br>", "Quarter: ", input$Cancer_Quarter_Waiting_Times_62, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select_62, "<br>", "Number Of Eligible Referrals Treated Within 62 Days : ", Cancer_Waiting_Times_62_days_T$NumberOfEligibleReferralsTreatedWithin62Days))
  
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>% 
    plot_ly(x = ~ Health_Board_Patient_Treatment,
            y = ~ NumberOfEligibleReferralsTreatedWithin62Days,
            color = ~ Health_Board_Patient_Treatment,
            type = 'bar',
            text= tooltip_1,
            hoverinfo="text") %>% 
    layout(xaxis = list(title = "Quarter"),
           yaxis = list(title = "Number of Patients Referred and Treated by a Healthboard in 62 days"))
  
})


output$cancer_waiting_list_overview_62_days_treatmenthb_compare <- renderPlotly({
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>% 
    select(-Percent_62_Days) %>%  ### Will only consider patients from initial Health Board before treatment for this graph
    filter(Health_Board_Patient %in% input$hb_name_waiting_times)  %>% 
    filter(CancerType == input$Cancer_Type_Input_Waiting_Times_Select_62)
  
  
  tooltip_1 <- c(paste0("Health Board: ", Cancer_Waiting_Times_62_days_T$Health_Board_Patient_Treatment, "<br>", "Quarter: ", Cancer_Waiting_Times_62_days_T$Quarter, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select_62, "<br>", "Number Of Eligible Referrals Treated Within 62 Days : ", Cancer_Waiting_Times_62_days_T$NumberOfEligibleReferralsTreatedWithin62Days))
  
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>% 
    plot_ly(x = ~ Quarter,
            y = ~ NumberOfEligibleReferralsTreatedWithin62Days,
            color = ~ Health_Board_Patient_Treatment,
            type = 'scatter',
            mode = 'lines',
            text= tooltip_1,
            hoverinfo="text") %>% 
    layout(xaxis = list(title = "Quarter"),
           yaxis = list(title = "Number of Patients Referred and Treated by a Healthboard in 62 days"))
  
})


