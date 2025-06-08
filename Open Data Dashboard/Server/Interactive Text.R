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
    paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>","Box Plot showing",   graphtype_label , "Cancer Statistics for", input$hb_name, "for", input$Cancer_Type_Input_Stats, "based on",  gender_final,  "</div>")
  ))
})