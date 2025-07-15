output$Cancer_Overview <- renderText({
  
  graphtype_label <- if (input$graphtype_input == "AllAges") {
    "Aggregated"
  } else if (input$graphtype_input == "CrudeRate") {
    "Crude Rate"
  } else if (input$graphtype_input == "EASR") {
    "European Age Sex Ratio"
  } else if (input$graphtype_input == "WASR") {
    "World Age Standardised Ratio"
  } else if (input$graphtype_input == "StandardisedRatio") {
    "Standardised Ratio"
  } else {
    input$graphtype_input
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
  paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>", graphtype_label, "graph showing Cancer", input$datatype_input, "across", input$hb_name, "for", input$Cancer_Type_Input, "</div>")
  ))
})

output$Cancer_Sex_Overview <- renderText({
  
  graphtype_label <- if (input$graphtype_input == "AllAges") {
    "Aggregated"
  } else if (input$graphtype_input == "CrudeRate") {
    "Crude Rate"
  } else if (input$graphtype_input == "EASR") {
    "European Age Sex Ratio"
  } else if (input$graphtype_input == "WASR") {
    "World Age Standardised Ratio"
  } else if (input$graphtype_input == "StandardisedRatio") {
    "Standardised Ratio"
  } else {
    input$graphtype_input
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>", "Gender based", graphtype_label, "graph showing Cancer", input$datatype_input, "across", input$hb_name, "for", input$Cancer_Type_Input, "</div>")
  ))
})

output$Cancer_ScatterPlot_Text <- renderText({

  gender_final <- if (input$Cancer_Gender_Input == "All") {
    "All Aggregrated Gender Statistics"
  } else if (input$Cancer_Gender_Input == "Male") {
    "Male Statistics"
  } else if (input$Cancer_Gender_Input == "Female") {
    "Female Statistics"
  } else {
    input$Cancer_Gender_Input
  }
  
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Scatter Plot showing Cancer Statistics for", input$hb_name, "for", input$Cancer_Type_Input_Stats, "based on",  gender_final,  "</div>")
  ))
})



output$Cancer_boxplot_Text <- renderText({
  
  gender_final <- if (input$Cancer_Gender_Input == "All") {
    "All Aggregrated Gender Statistics"
  } else if (input$Cancer_Gender_Input == "Male") {
    "Male Statistics"
  } else if (input$Cancer_Gender_Input == "Female") {
    "Female Statistics"
  } else {
    input$Cancer_Gender_Input
  }
  
  graphtype_label <- if (input$BoxPlot_Input_Cancer == "AllAges") {
    "Aggregated Incidence"
  } else if (input$BoxPlot_Input_Cancer == "AllDeaths") {
    "Aggregated Mortality"
  } else {
    input$BoxPlot_Input_Cancer
  }

  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Box Plot showing",   graphtype_label , "Cancer Statistics for", input$hb_name, "for", input$Cancer_Type_Input_Stats, "based on",  gender_final,  "</div>"),
    "<br>"
  ))
})

output$Text_31_Days_Eligible_Referals <- renderText({
  
 cancer_label <- if (input$Cancer_Type_Input_Waiting_Times_Select == "All Cancer Types") {
    "All"
  } else if (input$Cancer_Type_Input_Waiting_Times_Select == "Head & Neck") {
    "Head and Neck"
  } else {
    input$Cancer_Type_Input_Waiting_Times_Select
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Number of Eligible Referals Submitted from All Sources for Cancer Treatment in", input$hb_name_waiting_times, "for", cancer_label, "Cancer", "</div>"),
    "<br>"
  ))
})

output$Text_62_Days_Eligible_Referals <- renderText({
  
  cancer_label <- if (input$Cancer_Type_Input_Waiting_Times_Select_62 == "All Cancer Types") {
    "All"
  } else if (input$Cancer_Type_Input_Waiting_Times_Select_62 == "Head & Neck") {
    "Head and Neck"
  } else {
    input$Cancer_Type_Input_Waiting_Times_Select_62
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Number of Urgent Referrals Submitted from Sources for Cancer Treatment in", input$hb_name_waiting_times_62, "for", cancer_label, "Cancer", "</div>"),
    "<br>"
  ))
})



output$Text_31_Days_Eligible_Referals_Treated <- renderText({
  
  cancer_label <- if (input$Cancer_Type_Input_Waiting_Times_Select == "All Cancer Types") {
    "All"
  } else if (input$Cancer_Type_Input_Waiting_Times_Select == "Head & Neck") {
    "Head and Neck"
  } else {
    input$Cancer_Type_Input_Waiting_Times_Select
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Number of Eligible Referals Submitted from All Sources for Cancer Treatment that started their first treatment within 31 days of their decision to treat in", input$hb_name_waiting_times, "for", cancer_label, "Cancer broken down by Healthboard of Treatment", "in", input$Cancer_Quarter_Waiting_Times, "</div>"),
    "<br>"
  ))
})


output$Text_62_Days_Eligible_Referals_Treated <- renderText({
  
  cancer_label <- if (input$Cancer_Type_Input_Waiting_Times_Select_62 == "All Cancer Types") {
    "All"
  } else if (input$Cancer_Type_Input_Waiting_Times_Select_62 == "Head & Neck") {
    "Head and Neck"
  } else {
    input$Cancer_Type_Input_Waiting_Times_Select_62
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Number of Urgents Referals Submitted from Sources for Cancer Treatment that started their first treatment within 62 days of their decision to treat in", input$hb_name_waiting_times, "for", cancer_label, "Cancer broken down by Healthboard of Treatment", "in", input$Cancer_Quarter_Waiting_Times_62, "</div>"),
    "<br>"
  ))

})

output$Text_31_Days_Eligible_Referals_Treated_Compare <- renderText({
  
  cancer_label <- if (input$Cancer_Type_Input_Waiting_Times_Select == "All Cancer Types") {
    "All"
  } else if (input$Cancer_Type_Input_Waiting_Times_Select == "Head & Neck") {
    "Head and Neck"
  } else {
    input$Cancer_Type_Input_Waiting_Times_Select
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Number of Eligible Referals Submitted from All Sources for Cancer Treatment that started their first treatment within 31 days of their decision to treat in", input$hb_name_waiting_times, "for", cancer_label, "Cancer broken down by Healthboard of Treatment", "</div>"),
    "<br>"
  ))
})



output$Text_62_Days_Eligible_Referals_Treated_Compare <- renderText({
  
  cancer_label <- if (input$Cancer_Type_Input_Waiting_Times_Select_62 == "All Cancer Types") {
    "All"
  } else if (input$Cancer_Type_Input_Waiting_Times_Select_62 == "Head & Neck") {
    "Head and Neck"
  } else {
    input$Cancer_Type_Input_Waiting_Times_Select_62
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Number of Urgents Referals Submitted from Sources for Cancer Treatment that started their first treatment within 62 days of their decision to treat in", input$hb_name_waiting_times, "for", cancer_label, "Cancer broken down by Healthboard of Treatment", "</div>"),
    "<br>"
  ))
  
})

output$dynamic_title_metadata_commentary <- renderUI({
  view <- switch(input$metadata_commentary_switch,
                 "Metadata" = "Metadata ",
                 "Commentary" = "Commentary ")
  
  data_label <- switch(input$com_select,
                       "Cancer_Mortality_Section" = "- Cancer Mortality",
                       "Cancer_Incidence_Section" = "- Cancer Incidence",
                       "Cancer_Waiting_List_31_Day_Section"= "- Cancer 31 Day Standard",
                       "Cancer_Waiting_List_62_Day_Section"= "- Cancer 62 Day Standard"
                       )
  
  full_title <- paste0(view, data_label)
  

  div(style = 'color: #336699; font-size: 30px; font-weight: bold; margin-bottom: 5px;', full_title)
})



output$diagnostics_overview_graph_text <- renderText({
  run_chart_label <- if (input$show_run_chart_rules) {
    "Run Chart"
  } else {
    "Chart"
  }
  
  
  diagnostics_label <- if (input$diagnostics_description_type == "All Imaging") {
    "Diagnostic Imaging Procedure"
  } else if (input$diagnostics_description_type == "All Endoscopy") {
    "Endoscopy"
  } else {
    input$diagnostics_description_type
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>", run_chart_label, "showing the number of people waiting", input$diagnostics_waiting_times_input, "for a", diagnostics_label, "in", input$hb_name_diagnostics, "</div>"),
    "<br>"
  ))
  
})

output$diagnostics_overview_graph_percent_change_text <- renderText({
 bar_chart_label <- if (input$diagnostics_chart_type == "bar") {
    "Bar Chart"
  } else {
    "Line Chart"
  }
  
  
  diagnostics_label <- if (input$diagnostics_description_type == "All Imaging") {
    "Diagnostic Imaging Procedure"
  } else if (input$diagnostics_description_type == "All Endoscopy") {
    "Endoscopy"
  } else {
    input$diagnostics_description_type
  }
  
  HTML(paste0(
    "<br>",  # Adds space above the text
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>", bar_chart_label, "showing the percentage change in the number of people waiting", input$diagnostics_waiting_times_input, "for a", diagnostics_label, "in", input$hb_name_diagnostics, "</div>"),
    "<br>"
  ))
  
})

output$currentAEHeadersummary <- renderUI({
  req(input$HBName_Current_AE, input$AttendanceCategory_Current_AE, this_week(), last_week())
  
  week_1 <- format(latest_two_weeks()[1], "%d %B %Y")
  week_2 <- format(latest_two_weeks()[2], "%d %B %Y")
  
  ae_label <- if (input$AttendanceCategory_Current_AE == "All") {
    "all"
  } else if (input$AttendanceCategory_Current_AE == "Unplanned") {
    "unplanned"
  } else if (input$AttendanceCategory_Current_AE == "New planned") {
    "new planned"
} else {
  input$AttendanceCategory_Current_AE
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
   "Summary of Accident and Emergency Statistics in", input$HBName_Current_AE, "for", ae_label, "attendances", "comparing weeks ending", week_1, "and", week_2),
   "</div>"
  ))
})



output$currentAEHeaderyearcomparetitle <- renderUI({
  req(input$HBName_Current_AE, input$AttendanceCategory_Current_AE)

  
  ae_label <- if (input$AttendanceCategory_Current_AE == "All") {
    "both planned and unplanned care"
  } else if (input$AttendanceCategory_Current_AE == "Unplanned") {
    "unplanned care"
  } else if (input$AttendanceCategory_Current_AE == "New planned") {
    "new planned care"
  } else {
    input$AttendanceCategory_Current_AE
  }
  
  
  Description <- if (input$ae_recent_measure_select == "TotalAttendances") {
    "Total attendance"
  } else if (input$ae_recent_measure_select == "TotalOver4Hours") {
    "People waiting over 4 hours"
  } else if (input$ae_recent_measure_select == "TotalOver8Hours") {
    "People waiting over 8 hours"
  } 
 else if (input$ae_recent_measure_select == "TotalOver12Hours") {
  "People waiting over 12 hours" 
 }
  else if (input$ae_recent_measure_select == "TotalWithin4Hours") {
    "People seen within 4 hours" 
  }
else {
    input$ae_recent_measure_select
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
         Description, "for", ae_label, "at", input$HBName_Current_AE, "over the last five years by iso week"),
    "</div>"
  ))
})

output$currentAEHeaderyearaggregatedbargraph <- renderUI({
  req(input$HBName_Current_AE, input$AttendanceCategory_Current_AE)
  
  
  ae_label <- if (input$AttendanceCategory_Current_AE == "All") {
    "both planned and unplanned care"
  } else if (input$AttendanceCategory_Current_AE == "Unplanned") {
    "unplanned care"
  } else if (input$AttendanceCategory_Current_AE == "New planned") {
    "new planned care"
  } else {
    input$AttendanceCategory_Current_AE
  }
  
  
  Description <- if (input$ae_recent_measure_select_bar_graph == "TotalAttendances") {
    "Total attendance"
  } else if (input$ae_recent_measure_select_bar_graph == "TotalOver4Hours") {
    "Total number of people waiting over 4 hours"
  } else if (input$ae_recent_measure_select_bar_graph == "TotalOver8Hours") {
    "Total number of people waiting over 8 hours"
  } 
  else if (input$ae_recent_measure_select_bar_graph == "TotalOver12Hours") {
    "Total number of people waiting over 12 hours" 
  }
  else if (input$ae_recent_measure_select_bar_graph == "TotalWithin4Hours") {
    "Total numebr of people seen within 4 hours" 
  }
  else {
    input$ae_recent_measure_select_bar_graph
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          Description, "for", ae_label, "at", input$HBName_Current_AE, "each year over the last five years"),
    "</div>"
  ))
})

