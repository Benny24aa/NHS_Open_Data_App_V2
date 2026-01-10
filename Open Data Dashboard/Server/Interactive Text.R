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


output$currentAEHeadersummaryDemographic <- renderUI({
  req(input$HBName_Current_AE_Demographic, input$measure_type_demo_ae, input$AE_Department_Type_Input, this_month_demo_ae(), last_month_demo_ae())
  
  week_1 <- format(latest_two_months_ae_demo()[1], "%B %Y")
  week_2 <- format(latest_two_months_ae_demo()[2], "%B %Y")
  
  Description <- if (input$measure_type_demo_ae == "Deprivation") {
    "Deprivation Quintile"
  } else if (input$measure_type_demo_ae == "Age") {
    "Age Group"
  } 
  else {
    input$measure_type_demo_ae
  }
  
  
  DescriptionType <- if (input$AE_Department_Type_Input == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$AE_Department_Type_Input == "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$AE_Department_Type_Input
  }
  
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Summary of Accident and Emergency Statistics", "in", input$HBName_Current_AE_Demographic, "for all attendances comparing months ending", week_1, "and", week_2, "broken down by", Description, "in", DescriptionType),
    "</div>"
  ))
})

output$demographic_line_graph_title <- renderUI({
  req(input$HBName_Current_AE_Demographic, input$measure_type_demo_ae, input$AE_Department_Type_Input)
  
  Description <- if (input$measure_type_demo_ae == "Deprivation") {
    "Deprivation Quintile"
  } else if (input$measure_type_demo_ae == "Age") {
    "Age Group"
  } 
  else {
    input$measure_type_demo_ae
  }
  
  
  DescriptionType <- if (input$AE_Department_Type_Input == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$AE_Department_Type_Input == "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$AE_Department_Type_Input
  }
  
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Total Attendance", "in", input$HBName_Current_AE_Demographic, "broken down by", Description, "in", DescriptionType, "over the last seven years"),
    "</div>"
  ))
})

output$demographic_bar_graph_title <- renderUI({
  req(input$HBName_Current_AE_Demographic, input$measure_type_demo_ae, input$AE_Department_Type_Input)
  
  Description <- if (input$measure_type_demo_ae == "Deprivation") {
    "Deprivation Quintile"
  } else if (input$measure_type_demo_ae == "Age") {
    "Age Group"
  } 
  else {
    input$measure_type_demo_ae
  }
  
  
  DescriptionType <- if (input$AE_Department_Type_Input == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$AE_Department_Type_Input == "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$AE_Department_Type_Input
  }
  
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Total Attendance", "in", input$HBName_Current_AE_Demographic, "broken down by", Description, "in", DescriptionType, "aggregated each year over the last seven years"),
    "</div>"
  ))
})


output$currentAEHeadersummaryRef <- renderUI({

  week_1 <- format(latest_two_months_ae_referral()[1], "%B %Y")
  week_2 <- format(latest_two_months_ae_referral()[2], "%B %Y")
  
  
  DescriptionType <- if (input$Referral_AE_Department_Type == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$Referral_AE_Department_Type== "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$Referral_AE_Department_Type
  }
  
  AgeDescription <- if (input$Referral_AE_Department_Age == "All") {
    "all ages"
  } else if (input$Referral_AE_Department_Age == "18-24") {
    "people aged between 18 and 24"
  } else if (input$Referral_AE_Department_Age == "25-39") {
    "people aged between 25 and 39"
  }
  else if (input$Referral_AE_Department_Age == "40-64") {
    "people aged between 40 and 64"
  }
  else if (input$Referral_AE_Department_Age == "65-74") {
    "people aged between 65 and 74"
  }
  else if (input$Referral_AE_Department_Age == "75 plus") {
    "people aged over 75"
  }
  else if (input$Referral_AE_Department_Age == "Under 18") {
    "people aged under 18"
  }
  else if (input$Referral_AE_Department_Age == "Unknown") {
    "people of unknown age"
  }
  else {
    input$Referral_AE_Department_Type
  }
  
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Summary of Referral Source Accident and Emergency Statistics in", input$HBName_Current_AE_Referral, "for all attendances comparing months ending", week_1, "and", week_2, "in", DescriptionType, "for", AgeDescription),
    "</div>"
  ))
})

output$ref_line_graph_title <- renderUI({

  
  DescriptionType <- if (input$Referral_AE_Department_Type == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$Referral_AE_Department_Type== "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$Referral_AE_Department_Type
  }
  
  AgeDescription <- if (input$Referral_AE_Department_Age == "All") {
    "all ages"
  } else if (input$Referral_AE_Department_Age == "18-24") {
    "people aged between 18 and 24"
  } else if (input$Referral_AE_Department_Age == "25-39") {
    "people aged between 25 and 39"
  }
  else if (input$Referral_AE_Department_Age == "40-64") {
    "people aged between 40 and 64"
  }
  else if (input$Referral_AE_Department_Age == "65-74") {
    "people aged between 65 and 74"
  }
  else if (input$Referral_AE_Department_Age == "75 plus") {
    "people aged over 75"
  }
  else if (input$Referral_AE_Department_Age == "Under 18") {
    "people aged under 18"
  }
  else if (input$Referral_AE_Department_Age == "Unknown") {
    "people of unknown age"
  }
  else {
    input$Referral_AE_Department_Type
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Total number of attendances in", input$HBName_Current_AE_Referral, "based on referral type for", AgeDescription, "in", DescriptionType),
    "</div>"
  ))
})

output$currentAEHeadersummaryDischarge <- renderUI({
  
  week_1 <- format(latest_two_months_ae_discharge()[1], "%B %Y")
  week_2 <- format(latest_two_months_ae_discharge()[2], "%B %Y")
  
  
  DescriptionType <- if (input$Discharge_AE_Department_Type == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$Discharge_AE_Department_Type== "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$Discharge_AE_Department_Type
  }
  
  AgeDescription <- if (input$Discharge_AE_Department_Age == "All") {
    "all ages"
  } else if (input$Discharge_AE_Department_Age == "18-24") {
    "people aged between 18 and 24"
  } else if (input$Discharge_AE_Department_Age == "25-39") {
    "people aged between 25 and 39"
  }
  else if (input$Discharge_AE_Department_Age == "40-64") {
    "people aged between 40 and 64"
  }
  else if (input$Discharge_AE_Department_Age == "65-74") {
    "people aged between 65 and 74"
  }
  else if (input$Discharge_AE_Department_Age == "75 plus") {
    "people aged over 75"
  }
  else if (input$Discharge_AE_Department_Age == "Under 18") {
    "people aged under 18"
  }
  else if (input$Discharge_AE_Department_Age == "Unknown") {
    "people of unknown age"
  }
  else {
    input$Discharge_AE_Department_Type
  }
  
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Summary of Discharge Source Accident and Emergency Statistics in", input$HBName_Current_AE_Discharge, "for all discharges from hospital comparing months ending", week_1, "and", week_2, "from", DescriptionType, "for", AgeDescription),
    "</div>"
  ))
})


output$discharge_line_graph_title <- renderUI({
  
  
  week_1 <- format(latest_two_months_ae_discharge()[1], "%B %Y")
  week_2 <- format(latest_two_months_ae_discharge()[2], "%B %Y")
  
  
  DescriptionType <- if (input$Discharge_AE_Department_Type == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$Discharge_AE_Department_Type== "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$Discharge_AE_Department_Type
  }
  
  AgeDescription <- if (input$Discharge_AE_Department_Age == "All") {
    "all ages"
  } else if (input$Discharge_AE_Department_Age == "18-24") {
    "people aged between 18 and 24"
  } else if (input$Discharge_AE_Department_Age == "25-39") {
    "people aged between 25 and 39"
  }
  else if (input$Discharge_AE_Department_Age == "40-64") {
    "people aged between 40 and 64"
  }
  else if (input$Discharge_AE_Department_Age == "65-74") {
    "people aged between 65 and 74"
  }
  else if (input$Discharge_AE_Department_Age == "75 plus") {
    "people aged over 75"
  }
  else if (input$Discharge_AE_Department_Age == "Under 18") {
    "people aged under 18"
  }
  else if (input$Discharge_AE_Department_Age == "Unknown") {
    "people of unknown age"
  }
  else {
    input$Discharge_AE_Department_Type
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Total number of people discharged in", input$HBName_Current_AE_Discharge, "based on discharge type for", AgeDescription, "from", DescriptionType),
    "</div>"
  ))
})


output$currentAEHeadersummaryWhen <- renderUI({
  
  week_1 <- format(latest_two_months_ae_when()[1], "%B %Y")
  week_2 <- format(latest_two_months_ae_when()[2], "%B %Y")
  
  
  DescriptionType <- if (input$When_AE_Department_Type == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$When_AE_Department_Type== "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$When_AE_Department_Type
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Summary of When Accident and Emergency Statistics in", input$HBName_Current_AE_When, "for all attendances comparing months ending", week_1, "and", week_2, "from", DescriptionType),
    "</div>"
  ))
})


output$when_ae_title_graph_one <- renderUI({
  
  DescriptionType <- if (input$When_AE_Department_Type == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$When_AE_Department_Type== "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$When_AE_Department_Type
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Total number of attendances across", input$HBName_Current_AE_When, "attending", DescriptionType, "broken down by when they attended A&E"),
    "</div>"
  ))
})


output$when_ae_title_graph_two <- renderUI({
  
  DescriptionType <- if (input$When_AE_Department_Type == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$When_AE_Department_Type== "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$When_AE_Department_Type
  }
  
  DescriptionTypeWeekType <- if (input$When_AE_Week == "Weekday") {
    "weekdays"
  } else if (input$When_AE_Week == "Weekend") {
    "weekends"
  } 
  else {
    input$When_AE_Week
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Total number of attendances across", input$HBName_Current_AE_When, "attending", DescriptionType, "broken down by when they attended A&E based on data collected for", input$InOut_AE_Week, "attendances during", DescriptionTypeWeekType),
    "</div>"
  ))
})

output$when_ae_title_graph_three <- renderUI({
  
  DescriptionType <- if (input$When_AE_Department_Type == "Type 1") {
    "Emergency Departments (Type 1)"
  } else if (input$When_AE_Department_Type== "Type 3") {
    "Minor Injury Units (Type 3)"
  } 
  else {
    input$When_AE_Department_Type
  }
  
  
  DescriptionTypeWeekType <- if (input$When_AE_Week == "Weekday") {
    "weekdays"
  } else if (input$When_AE_Week == "Weekend") {
    "weekends"
  } 
  else {
    input$When_AE_Week
  }
  
  HTML(paste0(
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
          "Total number of attendances across", input$HBName_Current_AE_When, "attending", DescriptionType, "broken down by when they attended A&E based on data collected for", input$InOut_AE_Week, "attendances during", DescriptionTypeWeekType, "on the month commencing", input$month_input_ae_bar),
    "</div>"
  ))
})

output$model_information <- renderUI({
  
  
  Description <- if (input$AI_Model_Version == "Alpha_Model") {
    "The Alpha Model uses historical prescribing data and practice characteristics (such as practice size, population age profile, location, and time of year) to estimate how many items a GP practice would normally be expected to prescribe. It then compares these expected values with what actually happened, highlighting practices where the difference is unusually large.
Results show that most practices behave as expected, forming a clear central group, while a small number stand out with much higher or lower activity than predicted. These outliers are flagged for further review and provide an early warning signal rather than evidence of inappropriate prescribing."
  } else if (input$AI_Model_Version == "Beta_Model") {
    "The Beta Model uses historical prescribing data and practice characteristics (such as practice size, population age profile, location, and time of year) and also includes a much wider range of practice-level identifiers, such as individual practice codes, addresses, and postcodes, which makes the model overly complex. This over-factoring means the model focuses too heavily on exact identifiers rather than general prescribing patterns, leading it to under-estimate activity for some practices. As a result, the Beta Model shows more under-fitting than the Alpha Model and its outputs should be treated as exploratory while the feature set is refined."
  } 
  else {
    input$AI_Model_Version
  }
  
  
  
  HTML(paste0(
    paste(h4(
      Description)),
    "</div>"
  ))
})
