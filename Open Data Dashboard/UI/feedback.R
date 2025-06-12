Feedback <- tabPanel(
                     title = "Feedback", 
                     icon = icon("comment"),
         h4("We'd love your feedback!"),
         textAreaInput("feedback_text", "Your feedback:", ""),
         actionButton("submit_feedback", "Submit")
)