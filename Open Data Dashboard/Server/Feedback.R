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


# Feedback GDPR Information

observeEvent(input$gdpr_modal,
             showModal(modalDialog( # creates a modal: a pop-up box that contains text information
               title = "New content added and future updates",
               h4("Giving Feedback and Reporting Bugs - GDPR Information"),
               h5("We value your feedback and are committed to protecting your privacy. By submitting this form, you agree to the collection and use of your data for the sole purpose of reviewing and responding to your feedback about the NHS Open Data Application."),
               h4("What we collect"),
               tags$ul(
                 tags$li("Your comments and suggestions"),
                 tags$li("Optional contact details (e.g. name, email address)")),
               h4("Why we collect it"),
               tags$ul(
                 tags$li("To improve our services"),
                 tags$li("To respond to your query or suggestion (if contact details are provided))")),
               h4("Legal"),
               h5("We process this data under the UK GDPR Article 6(1)(e) – public task in the public interest, and where applicable, based on your consent (Article 6(1)(a))."),
               h4("Your Rights"),
               tags$ul(
                 tags$li("Access the data we hold about you"),
                 tags$li("Request corrections or deletion)"),
                 tags$li("Withdraw your consent at any time)")),
               h4("Data Retention"),
               h5("Your data will be stored securely and retained only as long as necessary to act on your feedback, and no longer than 12 months."),
               h4("Contact Us"),
               h5("Send an email to Harleyb101020@gmail.com if you wish to discuss any of the above."),
               size = "m",
               easyClose = TRUE, fade=FALSE,footer = modalButton("Close (Esc)"))))