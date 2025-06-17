Report_Bug <- tabPanel(title = "Report a Bug", 
                       icon = icon("bug"),
                       
                       fluidRow(
                         column(6,
                                h2("Report a Bug", style = "color:  #336699 ; font-weight: 600"))),
                       
                       fluidRow(
                         column(6, actionButton("gdpr_modal", tags$b("GDPR Information"),
                                                icon = icon('calendar-alt')))),
                       
         h4("Found a bug? Let us know."),
         textAreaInput("bug_text", "Describe the bug:", ""),
         actionButton("submit_bug", "Report")
)