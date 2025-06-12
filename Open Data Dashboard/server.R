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
    source(file.path("Server/Commentary and Metadata.R"), local = TRUE)$value
    source(file.path("Server/Interactive Text.R"), local = TRUE)$value
    
    
    ##### Feedback button
    
    observeEvent(input$submit_feedback, {
      # Get the feedback input
      feedback <- input$feedback_text
      
      # Create a data frame with timestamp and feedback
      feedback_entry <- data.frame(
        timestamp = Sys.time(),
        feedback = feedback,
        stringsAsFactors = FALSE
      )
      
      # Append to CSV
      file_path <- "feedback_log.csv"
      if (file.exists(file_path)) {
        write.table(feedback_entry, file = file_path, append = TRUE, 
                    sep = ",", row.names = FALSE, col.names = FALSE)
      } else {
        write.csv(feedback_entry, file = file_path, row.names = FALSE)
      }
      
      # Show thank-you modal
      showModal(modalDialog(
        title = "Thank You!",
        "Your feedback has been submitted.",
        easyClose = TRUE
      ))
      

    })
    
    
    
    
    
    
    
    
    # Report a bug button
    observeEvent(input$submit_bug, {
      bug_text <- trimws(input$bug_text)
      
      if (nchar(bug_text) == 0) {
        showModal(modalDialog(
          title = "Oops!",
          "Please describe the bug before submitting.",
          easyClose = TRUE
        ))
      } else {
        # Prepare a data frame with timestamp and bug text
        bug_entry <- data.frame(
          timestamp = Sys.time(),
          bug = bug_text,
          stringsAsFactors = FALSE
        )
        
        # Save to CSV (append if file exists)
        file_path <- "bug_reports.csv"
        if (file.exists(file_path)) {
          write.table(bug_entry, file = file_path, sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE)
        } else {
          write.csv(bug_entry, file = file_path, row.names = FALSE)
        }
        
        # Show thank you modal
        showModal(modalDialog(
          title = "Thank You!",
          "Your bug report has been submitted.",
          easyClose = TRUE
        ))
      }
      
    })

  }# End of Server

