Feedback <- tabPanel(
                     title = "Feedback", 
                     icon = icon("comment"),
                     
                     fluidRow(
                       column(6,
                              h2("Provide Feedback", style = "color:  #336699 ; font-weight: 600"))),
                     
                     fluidRow(
                       column(6, actionButton("gdpr_modal", tags$b("GDPR Information"),
                                              icon = icon('calendar-alt')))),
        h4("We'd love your feedback!"),
         textAreaInput("feedback_text", "Your feedback:", ""),
         actionButton("submit_feedback", "Submit")
)