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
