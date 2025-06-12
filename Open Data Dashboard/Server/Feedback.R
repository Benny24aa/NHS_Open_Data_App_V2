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