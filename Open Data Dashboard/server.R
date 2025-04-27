function(input, output) {

    filter_hb_main <- reactive({
      
      filter_hb_main <- HB_List[HB_List$HBName == input$hb_name,]
      
      return(filter_hb_main)
      
    })
    
    filter_datatype_main <- reactive({
      
      filter_datatype_main <- Cancer_Data_Type[Cancer_Data_Type$DataType == input$datatype_input,]
      
      return(filter_datatype_main)
      
    })
    
    filter_graph_type <- reactive({
      
      filter_graph_type <- GraphTypeOptions[GraphTypeOptions$Graph_Types == input$graphtype_input,]
      
      return(filter_Graph_type)
    })
    

    
    source(file.path("Server/Information Server.R"), local = TRUE)$value ## Information page sourcing in
    source(file.path("Server/Download Reference Files.R"), local = TRUE)$value
    source(file.path("Server/Download Cancer Data.R"), local = TRUE)$value
    source(file.path("Server/Overview Graphs.R"), local = TRUE)$value
  
  }# End of Server

