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