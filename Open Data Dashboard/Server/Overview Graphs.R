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

  
  
  Cancer_Waiting_Times_31_days_T$Quarter <- factor(Cancer_Waiting_Times_31_days_T$Quarter, 
                                                   levels = sort(unique(Cancer_Waiting_Times_31_days_T$Quarter)), 
                                                   ordered = TRUE)
  
  tooltip_1 <- c(paste0("Health Board: ", input$hb_name_waiting_times, "<br>", "Quarter: ", Cancer_Waiting_Times_31_days_T$Quarter, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select, "<br>", "Number Of Eligible Referrals 31 Day Standard : ", Cancer_Waiting_Times_31_days_T$NumberOfEligibleReferrals31DayStandard))
  
  unique_quarters <- sort(unique(Cancer_Waiting_Times_31_days_T$Quarter))
  tickvals <- unique_quarters[seq(1, length(unique_quarters), by = 8)]  # show every 8th quarter
  
  # Plot
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>%
    plot_ly(x = ~Quarter,
            y = ~NumberOfEligibleReferrals31DayStandard,
            type = 'scatter',
            mode = 'lines',
            text = tooltip_1,
            hoverinfo = "text") %>%
    layout(
      xaxis = list(title = "Quarter",
                   tickmode = "array",
                   tickvals = tickvals,
                   ticktext = tickvals),
      yaxis = list(title = "Referrals 31 Day Standard")
    )
  

    
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
  
  # Step 1: Filter and prepare the data
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>% 
    select(-Percent_31_Days) %>%  
    filter(Health_Board_Patient %in% input$hb_name_waiting_times,
           CancerType == input$Cancer_Type_Input_Waiting_Times_Select)
  
  # Step 2: Order Quarter and create QuarterIndex (numeric)
  Cancer_Waiting_Times_31_days_T$Quarter <- factor(
    Cancer_Waiting_Times_31_days_T$Quarter,
    levels = sort(unique(Cancer_Waiting_Times_31_days_T$Quarter)),
    ordered = TRUE
  )
  
  Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days_T %>%
    mutate(QuarterIndex = as.numeric(Quarter))
  
  # Step 3: Tooltip
  tooltip_1 <- paste0(
    "Health Board: ", Cancer_Waiting_Times_31_days_T$Health_Board_Patient_Treatment,
    "<br>Quarter: ", Cancer_Waiting_Times_31_days_T$Quarter,
    "<br>Cancer Type: ", Cancer_Waiting_Times_31_days_T$CancerType,
    "<br>Number Of Eligible Referrals Treated Within 31 Days: ",
    Cancer_Waiting_Times_31_days_T$NumberOfEligibleReferralsTreatedWithin31Days
  )
  
  # Step 4: Control tick labels (every 8th quarter)
  all_quarters <- levels(Cancer_Waiting_Times_31_days_T$Quarter)
  tick_positions <- seq(1, length(all_quarters), by = 8)
  tick_labels <- all_quarters[tick_positions]
  
  # Step 5: Plot using QuarterIndex
  plot_ly(
    data = Cancer_Waiting_Times_31_days_T,
    x = ~QuarterIndex,
    y = ~NumberOfEligibleReferralsTreatedWithin31Days,
    color = ~Health_Board_Patient_Treatment,
    type = 'scatter',
    mode = 'lines',
    text = tooltip_1,
    hoverinfo = "text"
  ) %>%
    layout(
      xaxis = list(
        title = "Quarter",
        tickmode = "array",
        tickvals = tick_positions,
        ticktext = tick_labels
      ),
      yaxis = list(title = "Referrals 31 Day Standard")
    )
  
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
  
  Cancer_Waiting_Times_62_days_T$Quarter <- factor(Cancer_Waiting_Times_62_days_T$Quarter, 
                                                   levels = sort(unique(Cancer_Waiting_Times_62_days_T$Quarter)), 
                                                   ordered = TRUE)
  
  
  
  tooltip_1 <- c(paste0("Health Board: ", input$hb_name_waiting_times, "<br>", "Quarter: ", Cancer_Waiting_Times_62_days_T$Quarter, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select_62, "<br>", "Number Of Eligible Referrals 62 Day Standard : ", Cancer_Waiting_Times_62_days_T$NumberOfEligibleReferrals62DayStandard))
  
  unique_quarters <- sort(unique(Cancer_Waiting_Times_62_days_T$Quarter))
  tickvals <- unique_quarters[seq(1, length(unique_quarters), by = 8)]  # show every 8th quarter
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>% 
    plot_ly(x = ~ Quarter,
            y = ~ NumberOfEligibleReferrals62DayStandard,
            type = 'scatter',
            mode = 'lines',
            text= tooltip_1,
            hoverinfo="text") %>%
    layout(
      xaxis = list(title = "Quarter",
                   tickmode = "array",
                   tickvals = tickvals,
                   ticktext = tickvals),
      yaxis = list(title = "Referrals 62 Day Standard")
    )
  
  
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
  
  # Step 2: Order Quarter and create QuarterIndex (numeric)
  Cancer_Waiting_Times_62_days_T$Quarter <- factor(
    Cancer_Waiting_Times_62_days_T$Quarter,
    levels = sort(unique(Cancer_Waiting_Times_62_days_T$Quarter)),
    ordered = TRUE
  )
  
  Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days_T %>%
    mutate(QuarterIndex = as.numeric(Quarter))
  
  # Step 3: Tooltip
  tooltip_1 <- c(paste0("Health Board: ", Cancer_Waiting_Times_62_days_T$Health_Board_Patient_Treatment, "<br>", "Quarter: ", Cancer_Waiting_Times_62_days_T$Quarter, "<br>", "Cancer Type: ", input$Cancer_Type_Input_Waiting_Times_Select_62, "<br>", "Number Of Eligible Referrals Treated Within 62 Days : ", Cancer_Waiting_Times_62_days_T$NumberOfEligibleReferralsTreatedWithin62Days))

  # Step 4: Control tick labels (every 8th quarter)
  all_quarters <- levels(Cancer_Waiting_Times_62_days_T$Quarter)
  tick_positions <- seq(1, length(all_quarters), by = 8)
  tick_labels <- all_quarters[tick_positions]
  
  # Step 5: Plot using QuarterIndex
  plot_ly(
    data = Cancer_Waiting_Times_62_days_T,
    x = ~QuarterIndex,
    y = ~NumberOfEligibleReferralsTreatedWithin62Days,
    color = ~Health_Board_Patient_Treatment,
    type = 'scatter',
    mode = 'lines',
    text = tooltip_1,
    hoverinfo = "text"
  ) %>%
    layout(
      xaxis = list(
        title = "Quarter",
        tickmode = "array",
        tickvals = tick_positions,
        ticktext = tick_labels
      ),
      yaxis = list(title = "Referrals 62 Day Standard")
    )
  
  
})

################################################################
################## Diagnostics Graphs ##########################
################################################################

output$diagnostics_description_filter <- renderUI({
  
  diagnostics_description_list <- diagnostic_description_list %>% 
    filter(DiagnosticTestType %in% input$diagnostics_test_type_input) %>% 
    pull(DiagnosticTestDescription)
  selectInput(inputId = "diagnostics_description_type", label = "Select a Diagnostics Breakdown", choices = diagnostics_description_list)
})

output$diagnostics_overview_graph <- renderPlotly({
  
  diagnostics_final_dataset_rates_filtered <- diagnostics_final_dataset_rates %>% 
    filter(HBName %in% input$hb_name_diagnostics,
           WaitingTime %in% input$diagnostics_waiting_times_input,
           DiagnosticTestType %in% input$diagnostics_test_type_input,
           DiagnosticTestDescription %in% input$diagnostics_description_type)
  
  
  # Ensure MonthEnding is Date
  if (!inherits(diagnostics_final_dataset_rates_filtered$MonthEnding, "Date")) {
    diagnostics_final_dataset_rates_filtered$MonthEnding <- as.Date(diagnostics_final_dataset_rates_filtered$MonthEnding)
  }
  
  diagnostics_final_dataset_rates_graph <- diagnostics_final_dataset_rates_filtered[order(diagnostics_final_dataset_rates_filtered$MonthEnding), ]
  
  #### Calculate Mean and Median for both run chart and normal chart
  avg_value <- mean(diagnostics_final_dataset_rates_graph$NumberOnList, na.rm = TRUE)
  median_value <- median(diagnostics_final_dataset_rates_graph$NumberOnList, na.rm = TRUE)
  
  diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules <- ""
  
  ### Run Chart Rules
  if (!is.null(input$show_run_chart_rules) && isTRUE(input$show_run_chart_rules)) {
    diagnostics_final_dataset_rates_graph$above_median <- ifelse(diagnostics_final_dataset_rates_graph$NumberOnList > median_value, 1, 0)
    run_lengths <- rle(diagnostics_final_dataset_rates_graph$above_median)
    run_flag <- rep(run_lengths$lengths >= 6, run_lengths$lengths)
    diagnostics_final_dataset_rates_graph$shift_flag <- run_flag
    
    diagnostics_final_dataset_rates_graph$trend_flag <- FALSE
    for (i in seq_len(nrow(diagnostics_final_dataset_rates_graph) - 4)) {
      window <- diagnostics_final_dataset_rates_graph$NumberOnList[i:(i + 4)]
      if (all(diff(window) > 0) || all(diff(window) < 0)) {
        diagnostics_final_dataset_rates_graph$trend_flag[i:(i + 4)] <- TRUE
      }
    }
    
    diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules[diagnostics_final_dataset_rates_graph$shift_flag] <- "Shift"
    diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules[diagnostics_final_dataset_rates_graph$trend_flag] <- "Trend"
  }
  
  diagnostics_final_dataset_rates_graph$tooltip <- paste0(
    "Health Board: ", diagnostics_final_dataset_rates_graph$HBName, "<br>",
    "Waiting Time Category: ", diagnostics_final_dataset_rates_graph$WaitingTime, "<br>",
    "Diagnostic Description: ", diagnostics_final_dataset_rates_graph$DiagnosticTestDescription, "<br>",
    "Diagnostic Type: ", diagnostics_final_dataset_rates_graph$DiagnosticTestType, "<br>",
    "Month: ", format(diagnostics_final_dataset_rates_graph$MonthEnding, "%b %Y"), "<br>",
    "Number on List: ", diagnostics_final_dataset_rates_graph$NumberOnList, "<br>",
    "Crude Rate: ", round(diagnostics_final_dataset_rates_graph$CrudeRate, 4),
    if (!is.null(input$show_run_chart_rules) && isTRUE(input$show_run_chart_rules)) {
      paste0("<br>Statistical Pattern: ", ifelse(diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules == "", "None", diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules))
    } else {
      ""
    }
  )
  
  shapes_list <- list()
  annotations_list <- list()
  
  if (!is.null(input$line_option_diagnostics) && input$line_option_diagnostics %in% c("Show Average Line", "Show Both")) {
    shapes_list <- c(shapes_list, list(
      list(
        type = "line",
        x0 = min(diagnostics_final_dataset_rates_graph$MonthEnding),
        x1 = max(diagnostics_final_dataset_rates_graph$MonthEnding),
        y0 = avg_value,
        y1 = avg_value,
        line = list(dash = 'dash', color = 'red'),
        xref = "x",
        yref = "y"
      )
    ))
    
    annotations_list <- c(annotations_list, list(
      list(
        x = max(diagnostics_final_dataset_rates_graph$MonthEnding),
        y = avg_value,
        text = paste0("Avg: ", round(avg_value)),
        showarrow = FALSE,
        xanchor = "left",
        yanchor = "bottom",
        font = list(color = "red")
      )
    ))
  }
  
  if (!is.null(input$line_option_diagnostics) && input$line_option_diagnostics %in% c("Show Median Line", "Show Both")) {
    shapes_list <- c(shapes_list, list(
      list(
        type = "line",
        x0 = min(diagnostics_final_dataset_rates_graph$MonthEnding),
        x1 = max(diagnostics_final_dataset_rates_graph$MonthEnding),
        y0 = median_value,
        y1 = median_value,
        line = list(dash = 'dot', color = 'blue'),
        xref = "x",
        yref = "y"
      )
    ))
    
    annotations_list <- c(annotations_list, list(
      list(
        x = max(diagnostics_final_dataset_rates_graph$MonthEnding),
        y = median_value,
        text = paste0("Median: ", round(median_value)),
        showarrow = FALSE,
        xanchor = "left",
        yanchor = "top",
        font = list(color = "blue")
      )
    ))
  }
  
  plot <- plot_ly(diagnostics_final_dataset_rates_graph,
                  x = ~MonthEnding,
                  y = ~NumberOnList,
                  type = 'scatter',
                  mode = 'lines+markers',
                  color = ~DiagnosticTestType,
                  text = ~tooltip,
                  hoverinfo = "text",
                  name = 'Number on List'
  )
  
  # Add special cause markers only if run chart is enabled and data exists
  if (!is.null(input$show_run_chart_rules) && isTRUE(input$show_run_chart_rules)) {
    if (any(diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules == "Trend")) {
      plot <- plot %>%
        add_trace(
          data = diagnostics_final_dataset_rates_graph[diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules == "Trend", ],
          x = ~MonthEnding,
          y = ~NumberOnList,
          type = 'scatter',
          mode = 'markers',
          marker = list(color = 'red', size = 10, symbol = 'circle'),
          name = 'Statistical Pattern: Trend'
        )
    }
    
    if (any(diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules == "Shift")) {
      plot <- plot %>%
        add_trace(
          data = diagnostics_final_dataset_rates_graph[diagnostics_final_dataset_rates_graph$diagnostics_run_chart_rules == "Shift", ],
          x = ~MonthEnding,
          y = ~NumberOnList,
          type = 'scatter',
          mode = 'markers',
          marker = list(color = 'blue', size = 10, symbol = 'circle'),
          name = 'Statistical Pattern: Shift'
        )
    }
  }
  plot %>%
    layout(
      shapes = shapes_list,
      annotations = annotations_list,
      xaxis = list(title = "Month"),
      yaxis = list(title = "Number on List")
    )
})


output$diagnostics_overview_graph_percent_change <- renderPlotly({
  
  diagnostics_final_dataset_rates_filtered <- diagnostics_final_dataset_rates %>% 
    filter(HBName %in% input$hb_name_diagnostics,
           WaitingTime %in% input$diagnostics_waiting_times_input,
           DiagnosticTestType %in% input$diagnostics_test_type_input,
           DiagnosticTestDescription %in% input$diagnostics_description_type)
  
  diagnostics_final_dataset_rates_filtered$MonthEnding <- as.Date(diagnostics_final_dataset_rates_filtered$MonthEnding)
  diagnostics_final_dataset_rates_filtered <- diagnostics_final_dataset_rates_filtered %>%
    arrange(MonthEnding) %>%
    mutate(
      PercentChange = (NumberOnList - lag(NumberOnList)) / lag(NumberOnList) * 100
    ) %>%
    filter(!is.na(PercentChange))  # remove NA rows
  
  diagnostics_final_dataset_rates_filtered <- diagnostics_final_dataset_rates_filtered %>%
    mutate(
      TooltipText = paste0(
        "Month: ", format(MonthEnding, "%b %Y"), "<br>",
        "HB: ", HBName, "<br>",
        "Test: ", DiagnosticTestDescription, "<br>",
        "Waiting Time: ", WaitingTime, "<br>",
        "Number on List: ", NumberOnList, "<br>",
        "Percent Change: ", round(PercentChange, 1), "%"
      )
    )
  
  chart_type <- input$diagnostics_chart_type
  
  if (chart_type == "line") {
    # Line chart
    plot <- plot_ly(
      diagnostics_final_dataset_rates_filtered,
      x = ~MonthEnding,
      y = ~PercentChange,
      type = 'scatter',
      mode = 'lines+markers',
      text = ~TooltipText,
      hoverinfo = 'text',
      name = 'Percent Change'
    )
  } else {
    # Bar chart with two traces: increase (red), decrease (green)
    increase_data <- diagnostics_final_dataset_rates_filtered %>%
      filter(PercentChange > 0)
    
    decrease_data <- diagnostics_final_dataset_rates_filtered %>%
      filter(PercentChange <= 0)
    
    plot <- plot_ly() %>%
      add_trace(
        data = increase_data,
        x = ~MonthEnding,
        y = ~PercentChange,
        type = 'bar',
        name = 'Increase',
        marker = list(color = 'red'),
        text = ~TooltipText,
        textposition = "none",
        hoverinfo = 'text'
      ) %>%
      add_trace(
        data = decrease_data,
        x = ~MonthEnding,
        y = ~PercentChange,
        type = 'bar',
        name = 'Decrease',
        marker = list(color = 'green'),
        text = ~TooltipText,
        textposition = "none",
        hoverinfo = 'text'
      )
  }
  
  plot %>%
    layout(
      yaxis = list(title = "Percent Change in Number on List"),
      xaxis = list(title = "Month")
    )
})

output$diagnostics_description_filter_compare <- renderUI({
  
  diagnostics_description_list <- diagnostic_description_list %>% 
    filter(DiagnosticTestType %in% input$diagnostics_test_type_input_compare) %>% 
    pull(DiagnosticTestDescription)
  selectInput(inputId = "diagnostics_description_type_compare", label = "Select a Diagnostics Breakdown", choices = diagnostics_description_list)
})



output$hb_compare_diagnostics_graph <- renderPlotly({
  diagnostics_final_dataset_rates_filtered <- diagnostics_final_dataset_rates %>% 
    filter(HBName %in% input$Healthboard_Diagnostics_Input_compare,
           WaitingTime %in% input$diagnostics_waiting_times_input_compare,
           DiagnosticTestType %in% input$diagnostics_test_type_input_compare,
           DiagnosticTestDescription %in% input$diagnostics_description_type_compare)
  
  diagnostics_final_dataset_rates_filtered <- diagnostics_final_dataset_rates_filtered %>%
    mutate(
      TooltipText = paste0(
        "Month: ", format(MonthEnding, "%b %Y"), "<br>",
        "Health Board: ", HBName, "<br>",
        "Test: ", DiagnosticTestDescription, "<br>",
        "Waiting Time: ", WaitingTime, "<br>",
        "Number on List: ", NumberOnList, "<br>",
        "Crude Rate: ", CrudeRate
      )
    )
  
  
  
  diagnostics_final_dataset_rates_filtered <- diagnostics_final_dataset_rates_filtered %>% 
    plot_ly(x = ~ MonthEnding,
            y = ~get(input$graphtype_input_compare_diagnostics),
            color = ~ HBName,
            type = 'scatter',
            mode = 'lines',
            text = ~TooltipText,
            hoverinfo="text" ) %>% 
    layout(xaxis = list(title = "Month Ending"),
           yaxis = list(title = input$graphtype_input_compare_diagnostics))
  
})

############### Accident and Emergency Graph Section



########## Accident and Emergency Filter for Hospitals
output$accident_emergency_hospital_filter <- renderUI({
  
  HB_Hospital_List <- HB_Hospital_List %>% 
    filter(HBName %in% input$hb_name_ae) %>% 
    pull(TreatmentLocationName)
  selectInput(inputId = "ae_weekly_hospital_input", label = "Select Hopsital", choices = HB_Hospital_List)
})

# Weekly Attendance AE Graph 
output$total_weekly_ae_attendance_graph <- renderPlotly({
  
  req(input$hb_name_ae, input$attendance_category_ae_input, 
      input$ae_weekly_hospital_input, input$ae_year_input)
  
  # Filter for selected years
  WeeklyAE_Filtered <- WeeklyAE %>%
    select(WeekEndingDate, AttendanceCategory, NumberOfAttendancesEpisode, HBName, TreatmentLocationName) %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% input$ae_year_input
    )
  
  # Validate there is data
  validate(
    need(nrow(WeeklyAE_Filtered) > 0, "No data available for selected filters")
  )
  
  # Current year(s) average
  avg_attendance <- mean(WeeklyAE_Filtered$NumberOfAttendancesEpisode, na.rm = TRUE)
  
  # Get selected years and define 2-year historic window
  selected_years <- sort(as.numeric(input$ae_year_input))
  min_selected_year <- min(selected_years)
  historic_years <- (min_selected_year - 2):(min_selected_year - 1)
  
  # Historic data
  WeeklyAE_Historic <- WeeklyAE %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% historic_years
    )
  
  # Historic overall average
  historic_avg <- mean(WeeklyAE_Historic$NumberOfAttendancesEpisode, na.rm = TRUE)
  
  # Add week numbers
  WeeklyAE_Historic <- WeeklyAE_Historic %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  # Weekly average for historic years
  HistoricWeeklyAvg <- WeeklyAE_Historic %>%
    group_by(WeekNum) %>%
    summarise(HistoricRollingAvg = mean(NumberOfAttendancesEpisode, na.rm = TRUE)) %>%
    ungroup()
  
  # Merge historic rolling average onto filtered data
  WeeklyAE_WithRolling <- WeeklyAE_Filtered %>%
    left_join(HistoricWeeklyAvg, by = "WeekNum")
  
  # Add tooltips
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(
      text = paste0(
        "Week Ending: ", format(WeekEndingDate, "%d-%b-%Y"), "<br>",
        "Health Board: ", HBName, "<br>",
        "Hospital: ", TreatmentLocationName, "<br>",
        "Category: ", AttendanceCategory, "<br>",
        "Attendances: ", NumberOfAttendancesEpisode
      )
    )
  
  WeeklyAE_WithRolling <- WeeklyAE_WithRolling %>%
    mutate(
      text_hist = paste0(
        "Week Ending: ", format(WeekEndingDate, "%d-%b-%Y"), "<br>",
        "Historic Weekly Avg: ", round(HistoricRollingAvg, 1)
      )
    )
  
  # Plot
  plot_ly() %>%
    add_trace(
      data = WeeklyAE_Filtered,
      x = ~WeekEndingDate,
      y = ~NumberOfAttendancesEpisode,
      color = ~HBName,
      type = 'scatter',
      mode = 'lines',
      name = 'Current Year(s)',
      text = ~text,
      hoverinfo = "text"
    ) %>%
    add_trace(
      data = WeeklyAE_WithRolling,
      x = ~WeekEndingDate,
      y = ~HistoricRollingAvg,
      type = 'scatter',
      mode = 'lines',
      name = paste0("Historic Weekly Avg (", paste(historic_years, collapse = "-"), ")"),
      line = list(dash = "dot", color = '#006400'),  # dark green
      text = ~text_hist,
      hoverinfo = "text"
    ) %>%
    layout(
      shapes = list(
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = avg_attendance,
          y1 = avg_attendance,
          line = list(color = "black", width = 2, dash = "dash")
        ),
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = historic_avg,
          y1 = historic_avg,
          line = list(color = "gray", width = 2, dash = "dot")
        )
      ),
      annotations = list(
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = avg_attendance,
          text = paste0("Avg ", paste0(input$ae_year_input, collapse = ", "), ": ", round(avg_attendance, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "bottom",
          font = list(size = 12, color = "black")
        ),
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = historic_avg,
          text = paste0("Avg ", paste(historic_years, collapse = "-"), ": ", round(historic_avg, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "top",
          font = list(size = 12, color = "gray")
        )
      ),
      legend = list(
        orientation = "h",
        x = 0,
        y = 1.1,
        xanchor = "left"
      ),
      xaxis = list(
        title = "Month",
        tickformat = "%b\n%Y",
        type = "date"
      ),
      yaxis = list(
        title = "Number of Attendances"
      )
    )
})

### Over Four Hours AE Graph

output$total_weekly_ae_over_four_hours_graph <- renderPlotly({
  
  req(input$hb_name_ae, input$attendance_category_ae_input, 
      input$ae_weekly_hospital_input, input$ae_year_input)
  
  # Filter for selected years
  WeeklyAE_Filtered <- WeeklyAE %>%
    select(WeekEndingDate, AttendanceCategory, NumberOver4HoursEpisode, HBName, TreatmentLocationName) %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% input$ae_year_input
    )
  
  # Validate there is data
  validate(
    need(nrow(WeeklyAE_Filtered) > 0, "No data available for selected filters")
  )
  
  # Current year(s) average
  avg_attendance <- mean(WeeklyAE_Filtered$NumberOver4HoursEpisode, na.rm = TRUE)
  
  # Get selected years and define 2-year historic window
  selected_years <- sort(as.numeric(input$ae_year_input))
  min_selected_year <- min(selected_years)
  historic_years <- (min_selected_year - 2):(min_selected_year - 1)
  
  # Historic data
  WeeklyAE_Historic <- WeeklyAE %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% historic_years
    )
  
  # Historic overall average
  historic_avg <- mean(WeeklyAE_Historic$NumberOver4HoursEpisode, na.rm = TRUE)
  
  # Add week numbers
  WeeklyAE_Historic <- WeeklyAE_Historic %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  # Weekly average for historic years
  HistoricWeeklyAvg <- WeeklyAE_Historic %>%
    group_by(WeekNum) %>%
    summarise(HistoricRollingAvg = mean(NumberOver4HoursEpisode, na.rm = TRUE)) %>%
    ungroup()
  
  # Merge historic rolling average onto filtered data
  WeeklyAE_WithRolling <- WeeklyAE_Filtered %>%
    left_join(HistoricWeeklyAvg, by = "WeekNum")
  
  # Plot
  plot_ly() %>%
    add_trace(
      data = WeeklyAE_Filtered,
      x = ~WeekEndingDate,
      y = ~NumberOver4HoursEpisode,
      color = ~HBName,
      type = 'scatter',
      mode = 'lines',
      name = 'Current Year(s)',
      hoverinfo = "text"
    ) %>%
    add_trace(
      data = WeeklyAE_WithRolling,
      x = ~WeekEndingDate,
      y = ~HistoricRollingAvg,
      type = 'scatter',
      mode = 'lines',
      name = paste0("Historic Weekly Avg (", paste(historic_years, collapse = "-"), ")"),
      line = list(dash = "dot", color = '#006400'),  # dark green
      hoverinfo = "text"
    ) %>%
    layout(
      shapes = list(
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = avg_attendance,
          y1 = avg_attendance,
          line = list(color = "black", width = 2, dash = "dash")
        ),
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = historic_avg,
          y1 = historic_avg,
          line = list(color = "gray", width = 2, dash = "dot")
        )
      ),
      annotations = list(
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = avg_attendance,
          text = paste0("Avg ", paste0(input$ae_year_input, collapse = ", "), ": ", round(avg_attendance, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "bottom",
          font = list(size = 12, color = "black")
        ),
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = historic_avg,
          text = paste0("Avg ", paste(historic_years, collapse = "-"), ": ", round(historic_avg, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "top",
          font = list(size = 12, color = "gray")
        )
      ),
      legend = list(
        orientation = "h",
        x = 0,
        y = 1.1,
        xanchor = "left"
      ),
      xaxis = list(
        title = "Month",
        tickformat = "%b\n%Y",
        type = "date"
      ),
      yaxis = list(
        title = "Number of People Seen Over 4 Hours"
      )
    )
})

### Within 4 hours AE Graph

output$total_weekly_ae_within_four_hours_graph <- renderPlotly({
  
  req(input$hb_name_ae, input$attendance_category_ae_input, 
      input$ae_weekly_hospital_input, input$ae_year_input)
  
  # Filter for selected years
  WeeklyAE_Filtered <- WeeklyAE %>%
    select(WeekEndingDate, AttendanceCategory, NumberWithin4HoursEpisode, HBName, TreatmentLocationName) %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% input$ae_year_input
    )
  
  # Validate there is data
  validate(
    need(nrow(WeeklyAE_Filtered) > 0, "No data available for selected filters")
  )
  
  # Current year(s) average
  avg_attendance <- mean(WeeklyAE_Filtered$NumberWithin4HoursEpisode, na.rm = TRUE)
  
  # Get selected years and define 2-year historic window
  selected_years <- sort(as.numeric(input$ae_year_input))
  min_selected_year <- min(selected_years)
  historic_years <- (min_selected_year - 2):(min_selected_year - 1)
  
  # Historic data
  WeeklyAE_Historic <- WeeklyAE %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% historic_years
    )
  
  # Historic overall average
  historic_avg <- mean(WeeklyAE_Historic$NumberWithin4HoursEpisode, na.rm = TRUE)
  
  # Add week numbers
  WeeklyAE_Historic <- WeeklyAE_Historic %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  # Weekly average for historic years
  HistoricWeeklyAvg <- WeeklyAE_Historic %>%
    group_by(WeekNum) %>%
    summarise(HistoricRollingAvg = mean(NumberWithin4HoursEpisode, na.rm = TRUE)) %>%
    ungroup()
  
  # Merge historic rolling average onto filtered data
  WeeklyAE_WithRolling <- WeeklyAE_Filtered %>%
    left_join(HistoricWeeklyAvg, by = "WeekNum")
  
  # Plot
  plot_ly() %>%
    add_trace(
      data = WeeklyAE_Filtered,
      x = ~WeekEndingDate,
      y = ~NumberWithin4HoursEpisode,
      color = ~HBName,
      type = 'scatter',
      mode = 'lines',
      name = 'Current Year(s)',
      hoverinfo = "text"
    ) %>%
    add_trace(
      data = WeeklyAE_WithRolling,
      x = ~WeekEndingDate,
      y = ~HistoricRollingAvg,
      type = 'scatter',
      mode = 'lines',
      name = paste0("Historic Weekly Avg (", paste(historic_years, collapse = "-"), ")"),
      line = list(dash = "dot", color = '#006400'),  # dark green
      hoverinfo = "text"
    ) %>%
    layout(
      shapes = list(
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = avg_attendance,
          y1 = avg_attendance,
          line = list(color = "black", width = 2, dash = "dash")
        ),
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = historic_avg,
          y1 = historic_avg,
          line = list(color = "gray", width = 2, dash = "dot")
        )
      ),
      annotations = list(
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = avg_attendance,
          text = paste0("Avg ", paste0(input$ae_year_input, collapse = ", "), ": ", round(avg_attendance, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "bottom",
          font = list(size = 12, color = "black")
        ),
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = historic_avg,
          text = paste0("Avg ", paste(historic_years, collapse = "-"), ": ", round(historic_avg, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "top",
          font = list(size = 12, color = "gray")
        )
      ),
      legend = list(
        orientation = "h",
        x = 0,
        y = 1.1,
        xanchor = "left"
      ),
      xaxis = list(
        title = "Month",
        tickformat = "%b\n%Y",
        type = "date"
      ),
      yaxis = list(
        title = "Number of People Seen within 4 Hours"
      )
    )
})
### Within 4 hours AE Percentage Graph

output$total_weekly_ae_within_four_hours_percentage_graph <- renderPlotly({
  
  req(input$hb_name_ae, input$attendance_category_ae_input, 
      input$ae_weekly_hospital_input, input$ae_year_input)
  
  # Filter for selected years
  WeeklyAE_Filtered <- WeeklyAE %>%
    select(WeekEndingDate, AttendanceCategory, PercentageWithin4HoursEpisode, HBName, TreatmentLocationName) %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% input$ae_year_input
    )
  
  # Validate there is data
  validate(
    need(nrow(WeeklyAE_Filtered) > 0, "No data available for selected filters")
  )
  
  # Current year(s) average
  avg_attendance <- mean(WeeklyAE_Filtered$PercentageWithin4HoursEpisode, na.rm = TRUE)
  
  # Get selected years and define 2-year historic window
  selected_years <- sort(as.numeric(input$ae_year_input))
  min_selected_year <- min(selected_years)
  historic_years <- (min_selected_year - 2):(min_selected_year - 1)
  
  # Historic data
  WeeklyAE_Historic <- WeeklyAE %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% historic_years
    )
  
  # Historic overall average
  historic_avg <- mean(WeeklyAE_Historic$PercentageWithin4HoursEpisode, na.rm = TRUE)
  
  # Add week numbers
  WeeklyAE_Historic <- WeeklyAE_Historic %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  # Weekly average for historic years
  HistoricWeeklyAvg <- WeeklyAE_Historic %>%
    group_by(WeekNum) %>%
    summarise(HistoricRollingAvg = mean(PercentageWithin4HoursEpisode, na.rm = TRUE)) %>%
    ungroup()
  
  # Merge historic rolling average onto filtered data
  WeeklyAE_WithRolling <- WeeklyAE_Filtered %>%
    left_join(HistoricWeeklyAvg, by = "WeekNum")
  
  # Plot
  plot_ly() %>%
    add_trace(
      data = WeeklyAE_Filtered,
      x = ~WeekEndingDate,
      y = ~PercentageWithin4HoursEpisode,
      color = ~HBName,
      type = 'scatter',
      mode = 'lines',
      name = 'Current Year(s)',
      hoverinfo = "text"
    ) %>%
    add_trace(
      data = WeeklyAE_WithRolling,
      x = ~WeekEndingDate,
      y = ~HistoricRollingAvg,
      type = 'scatter',
      mode = 'lines',
      name = paste0("Historic Weekly Avg (", paste(historic_years, collapse = "-"), ")"),
      line = list(dash = "dot", color = '#006400'),  # dark green
      hoverinfo = "text"
    ) %>%
    layout(
      shapes = list(
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = avg_attendance,
          y1 = avg_attendance,
          line = list(color = "black", width = 2, dash = "dash")
        ),
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = historic_avg,
          y1 = historic_avg,
          line = list(color = "gray", width = 2, dash = "dot")
        )
      ),
      annotations = list(
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = avg_attendance,
          text = paste0("Avg ", paste0(input$ae_year_input, collapse = ", "), ": ", round(avg_attendance, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "bottom",
          font = list(size = 12, color = "black")
        ),
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = historic_avg,
          text = paste0("Avg ", paste(historic_years, collapse = "-"), ": ", round(historic_avg, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "top",
          font = list(size = 12, color = "gray")
        )
      ),
      legend = list(
        orientation = "h",
        x = 0,
        y = 1.1,
        xanchor = "left"
      ),
      xaxis = list(
        title = "Month",
        tickformat = "%b\n%Y",
        type = "date"
      ),
      yaxis = list(
        title = "Percent of People Seen Within 4 Hours (%)"
      )
    )
})

### 8 hours AE Graph

output$total_weekly_ae_over_eight_hours_graph <- renderPlotly({
  
  req(input$hb_name_ae, input$attendance_category_ae_input, 
      input$ae_weekly_hospital_input, input$ae_year_input)
  
  # Filter for selected years
  WeeklyAE_Filtered <- WeeklyAE %>%
    select(WeekEndingDate, AttendanceCategory, NumberOver8HoursEpisode, HBName, TreatmentLocationName) %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% input$ae_year_input
    )
  
  # Validate there is data
  validate(
    need(nrow(WeeklyAE_Filtered) > 0, "No data available for selected filters")
  )
  
  # Current year(s) average
  avg_attendance <- mean(WeeklyAE_Filtered$NumberOver8HoursEpisode, na.rm = TRUE)
  
  # Get selected years and define 2-year historic window
  selected_years <- sort(as.numeric(input$ae_year_input))
  min_selected_year <- min(selected_years)
  historic_years <- (min_selected_year - 2):(min_selected_year - 1)
  
  # Historic data
  WeeklyAE_Historic <- WeeklyAE %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% historic_years
    )
  
  # Historic overall average
  historic_avg <- mean(WeeklyAE_Historic$NumberOver8HoursEpisode, na.rm = TRUE)
  
  # Add week numbers
  WeeklyAE_Historic <- WeeklyAE_Historic %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  # Weekly average for historic years
  HistoricWeeklyAvg <- WeeklyAE_Historic %>%
    group_by(WeekNum) %>%
    summarise(HistoricRollingAvg = mean(NumberOver8HoursEpisode, na.rm = TRUE)) %>%
    ungroup()
  
  # Merge historic rolling average onto filtered data
  WeeklyAE_WithRolling <- WeeklyAE_Filtered %>%
    left_join(HistoricWeeklyAvg, by = "WeekNum")
  
  # Plot
  plot_ly() %>%
    add_trace(
      data = WeeklyAE_Filtered,
      x = ~WeekEndingDate,
      y = ~NumberOver8HoursEpisode,
      color = ~HBName,
      type = 'scatter',
      mode = 'lines',
      name = 'Current Year(s)',
      hoverinfo = "text"
    ) %>%
    add_trace(
      data = WeeklyAE_WithRolling,
      x = ~WeekEndingDate,
      y = ~HistoricRollingAvg,
      type = 'scatter',
      mode = 'lines',
      name = paste0("Historic Weekly Avg (", paste(historic_years, collapse = "-"), ")"),
      line = list(dash = "dot", color = '#006400'),  # dark green
      hoverinfo = "text"
    ) %>%
    layout(
      shapes = list(
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = avg_attendance,
          y1 = avg_attendance,
          line = list(color = "black", width = 2, dash = "dash")
        ),
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = historic_avg,
          y1 = historic_avg,
          line = list(color = "gray", width = 2, dash = "dot")
        )
      ),
      annotations = list(
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = avg_attendance,
          text = paste0("Avg ", paste0(input$ae_year_input, collapse = ", "), ": ", round(avg_attendance, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "bottom",
          font = list(size = 12, color = "black")
        ),
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = historic_avg,
          text = paste0("Avg ", paste(historic_years, collapse = "-"), ": ", round(historic_avg, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "top",
          font = list(size = 12, color = "gray")
        )
      ),
      legend = list(
        orientation = "h",
        x = 0,
        y = 1.1,
        xanchor = "left"
      ),
      xaxis = list(
        title = "Month",
        tickformat = "%b\n%Y",
        type = "date"
      ),
      yaxis = list(
        title = "Number of People Seen in over 8 Hours"
      )
    )
})

### Within 8 hours AE Percentage Graph

output$total_weekly_ae_over_eight_hours_percentage_graph <- renderPlotly({
  
  req(input$hb_name_ae, input$attendance_category_ae_input, 
      input$ae_weekly_hospital_input, input$ae_year_input)
  
  # Filter for selected years
  WeeklyAE_Filtered <- WeeklyAE %>%
    select(WeekEndingDate, AttendanceCategory, PercentageOver8HoursEpisode, HBName, TreatmentLocationName) %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% input$ae_year_input
    )
  
  # Validate there is data
  validate(
    need(nrow(WeeklyAE_Filtered) > 0, "No data available for selected filters")
  )
  
  # Current year(s) average
  avg_attendance <- mean(WeeklyAE_Filtered$PercentageOver8HoursEpisode, na.rm = TRUE)
  
  # Get selected years and define 2-year historic window
  selected_years <- sort(as.numeric(input$ae_year_input))
  min_selected_year <- min(selected_years)
  historic_years <- (min_selected_year - 2):(min_selected_year - 1)
  
  # Historic data
  WeeklyAE_Historic <- WeeklyAE %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% historic_years
    )
  
  # Historic overall average
  historic_avg <- mean(WeeklyAE_Historic$PercentageOver8HoursEpisode, na.rm = TRUE)
  
  # Add week numbers
  WeeklyAE_Historic <- WeeklyAE_Historic %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  # Weekly average for historic years
  HistoricWeeklyAvg <- WeeklyAE_Historic %>%
    group_by(WeekNum) %>%
    summarise(HistoricRollingAvg = mean(PercentageOver8HoursEpisode, na.rm = TRUE)) %>%
    ungroup()
  
  # Merge historic rolling average onto filtered data
  WeeklyAE_WithRolling <- WeeklyAE_Filtered %>%
    left_join(HistoricWeeklyAvg, by = "WeekNum")
  
  # Plot
  plot_ly() %>%
    add_trace(
      data = WeeklyAE_Filtered,
      x = ~WeekEndingDate,
      y = ~PercentageOver8HoursEpisode,
      color = ~HBName,
      type = 'scatter',
      mode = 'lines',
      name = 'Current Year(s)',
      hoverinfo = "text"
    ) %>%
    add_trace(
      data = WeeklyAE_WithRolling,
      x = ~WeekEndingDate,
      y = ~HistoricRollingAvg,
      type = 'scatter',
      mode = 'lines',
      name = paste0("Historic Weekly Avg (", paste(historic_years, collapse = "-"), ")"),
      line = list(dash = "dot", color = '#006400'),  # dark green
      hoverinfo = "text"
    ) %>%
    layout(
      shapes = list(
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = avg_attendance,
          y1 = avg_attendance,
          line = list(color = "black", width = 2, dash = "dash")
        ),
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = historic_avg,
          y1 = historic_avg,
          line = list(color = "gray", width = 2, dash = "dot")
        )
      ),
      annotations = list(
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = avg_attendance,
          text = paste0("Avg ", paste0(input$ae_year_input, collapse = ", "), ": ", round(avg_attendance, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "bottom",
          font = list(size = 12, color = "black")
        ),
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = historic_avg,
          text = paste0("Avg ", paste(historic_years, collapse = "-"), ": ", round(historic_avg, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "top",
          font = list(size = 12, color = "gray")
        )
      ),
      legend = list(
        orientation = "h",
        x = 0,
        y = 1.1,
        xanchor = "left"
      ),
      xaxis = list(
        title = "Month",
        tickformat = "%b\n%Y",
        type = "date"
      ),
      yaxis = list(
        title = "Percent of People Seen in over 8 Hours (%)"
      )
    )
})
### 12 hours AE Graph

output$total_weekly_ae_over_twelve_hours_graph <- renderPlotly({
  
  req(input$hb_name_ae, input$attendance_category_ae_input, 
      input$ae_weekly_hospital_input, input$ae_year_input)
  
  # Filter for selected years
  WeeklyAE_Filtered <- WeeklyAE %>%
    select(WeekEndingDate, AttendanceCategory, NumberOver12HoursEpisode, HBName, TreatmentLocationName) %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% input$ae_year_input
    )
  
  # Validate there is data
  validate(
    need(nrow(WeeklyAE_Filtered) > 0, "No data available for selected filters")
  )
  
  # Current year(s) average
  avg_attendance <- mean(WeeklyAE_Filtered$NumberOver12HoursEpisode, na.rm = TRUE)
  
  # Get selected years and define 2-year historic window
  selected_years <- sort(as.numeric(input$ae_year_input))
  min_selected_year <- min(selected_years)
  historic_years <- (min_selected_year - 2):(min_selected_year - 1)
  
  # Historic data
  WeeklyAE_Historic <- WeeklyAE %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% historic_years
    )
  
  # Historic overall average
  historic_avg <- mean(WeeklyAE_Historic$NumberOver12HoursEpisode, na.rm = TRUE)
  
  # Add week numbers
  WeeklyAE_Historic <- WeeklyAE_Historic %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  # Weekly average for historic years
  HistoricWeeklyAvg <- WeeklyAE_Historic %>%
    group_by(WeekNum) %>%
    summarise(HistoricRollingAvg = mean(NumberOver12HoursEpisode, na.rm = TRUE)) %>%
    ungroup()
  
  # Merge historic rolling average onto filtered data
  WeeklyAE_WithRolling <- WeeklyAE_Filtered %>%
    left_join(HistoricWeeklyAvg, by = "WeekNum")
  
  # Plot
  plot_ly() %>%
    add_trace(
      data = WeeklyAE_Filtered,
      x = ~WeekEndingDate,
      y = ~NumberOver12HoursEpisode,
      color = ~HBName,
      type = 'scatter',
      mode = 'lines',
      name = 'Current Year(s)',
      hoverinfo = "text"
    ) %>%
    add_trace(
      data = WeeklyAE_WithRolling,
      x = ~WeekEndingDate,
      y = ~HistoricRollingAvg,
      type = 'scatter',
      mode = 'lines',
      name = paste0("Historic Weekly Avg (", paste(historic_years, collapse = "-"), ")"),
      line = list(dash = "dot", color = '#006400'),  # dark green
      hoverinfo = "text"
    ) %>%
    layout(
      shapes = list(
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = avg_attendance,
          y1 = avg_attendance,
          line = list(color = "black", width = 2, dash = "dash")
        ),
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = historic_avg,
          y1 = historic_avg,
          line = list(color = "gray", width = 2, dash = "dot")
        )
      ),
      annotations = list(
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = avg_attendance,
          text = paste0("Avg ", paste0(input$ae_year_input, collapse = ", "), ": ", round(avg_attendance, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "bottom",
          font = list(size = 12, color = "black")
        ),
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = historic_avg,
          text = paste0("Avg ", paste(historic_years, collapse = "-"), ": ", round(historic_avg, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "top",
          font = list(size = 12, color = "gray")
        )
      ),
      legend = list(
        orientation = "h",
        x = 0,
        y = 1.1,
        xanchor = "left"
      ),
      xaxis = list(
        title = "Month",
        tickformat = "%b\n%Y",
        type = "date"
      ),
      yaxis = list(
        title = "Number of People seen in over 12 Hours"
      )
    )
})

### Within 12 hours AE Percentage Graph

output$total_weekly_ae_over_twelve_hours_percentage_graph <- renderPlotly({
  
  req(input$hb_name_ae, input$attendance_category_ae_input, 
      input$ae_weekly_hospital_input, input$ae_year_input)
  
  # Filter for selected years
  WeeklyAE_Filtered <- WeeklyAE %>%
    select(WeekEndingDate, AttendanceCategory, PercentageOver12HoursEpisode, HBName, TreatmentLocationName) %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% input$ae_year_input
    )
  
  # Validate there is data
  validate(
    need(nrow(WeeklyAE_Filtered) > 0, "No data available for selected filters")
  )
  
  # Current year(s) average
  avg_attendance <- mean(WeeklyAE_Filtered$PercentageOver12HoursEpisode, na.rm = TRUE)
  
  # Get selected years and define 2-year historic window
  selected_years <- sort(as.numeric(input$ae_year_input))
  min_selected_year <- min(selected_years)
  historic_years <- (min_selected_year - 2):(min_selected_year - 1)
  
  # Historic data
  WeeklyAE_Historic <- WeeklyAE %>%
    filter(
      HBName %in% input$hb_name_ae,
      AttendanceCategory %in% input$attendance_category_ae_input,
      TreatmentLocationName %in% input$ae_weekly_hospital_input,
      lubridate::year(WeekEndingDate) %in% historic_years
    )
  
  # Historic overall average
  historic_avg <- mean(WeeklyAE_Historic$PercentageOver12HoursEpisode, na.rm = TRUE)
  
  # Add week numbers
  WeeklyAE_Historic <- WeeklyAE_Historic %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  WeeklyAE_Filtered <- WeeklyAE_Filtered %>%
    mutate(WeekNum = lubridate::isoweek(WeekEndingDate))
  
  # Weekly average for historic years
  HistoricWeeklyAvg <- WeeklyAE_Historic %>%
    group_by(WeekNum) %>%
    summarise(HistoricRollingAvg = mean(PercentageOver12HoursEpisode, na.rm = TRUE)) %>%
    ungroup()
  
  # Merge historic rolling average onto filtered data
  WeeklyAE_WithRolling <- WeeklyAE_Filtered %>%
    left_join(HistoricWeeklyAvg, by = "WeekNum")
  
  # Plot
  plot_ly() %>%
    add_trace(
      data = WeeklyAE_Filtered,
      x = ~WeekEndingDate,
      y = ~PercentageOver12HoursEpisode,
      color = ~HBName,
      type = 'scatter',
      mode = 'lines',
      name = 'Current Year(s)',
      hoverinfo = "text"
    ) %>%
    add_trace(
      data = WeeklyAE_WithRolling,
      x = ~WeekEndingDate,
      y = ~HistoricRollingAvg,
      type = 'scatter',
      mode = 'lines',
      name = paste0("Historic Weekly Avg (", paste(historic_years, collapse = "-"), ")"),
      line = list(dash = "dot", color = '#006400'),  # dark green
      hoverinfo = "text"
    ) %>%
    layout(
      shapes = list(
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = avg_attendance,
          y1 = avg_attendance,
          line = list(color = "black", width = 2, dash = "dash")
        ),
        list(
          type = "line",
          x0 = min(WeeklyAE_Filtered$WeekEndingDate),
          x1 = max(WeeklyAE_Filtered$WeekEndingDate),
          y0 = historic_avg,
          y1 = historic_avg,
          line = list(color = "gray", width = 2, dash = "dot")
        )
      ),
      annotations = list(
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = avg_attendance,
          text = paste0("Avg ", paste0(input$ae_year_input, collapse = ", "), ": ", round(avg_attendance, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "bottom",
          font = list(size = 12, color = "black")
        ),
        list(
          x = max(WeeklyAE_Filtered$WeekEndingDate),
          y = historic_avg,
          text = paste0("Avg ", paste(historic_years, collapse = "-"), ": ", round(historic_avg, 0)),
          xref = "x",
          yref = "y",
          showarrow = FALSE,
          xanchor = "left",
          yanchor = "top",
          font = list(size = 12, color = "gray")
        )
      ),
      legend = list(
        orientation = "h",
        x = 0,
        y = 1.1,
        xanchor = "left"
      ),
      xaxis = list(
        title = "Month",
        tickformat = "%b\n%Y",
        type = "date"
      ),
      yaxis = list(
        title = "Percent of People Seen in over 12 Hours (%)"
      )
    )
})