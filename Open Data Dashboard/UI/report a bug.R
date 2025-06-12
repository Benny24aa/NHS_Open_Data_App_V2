Report_Bug <- tabPanel(title = "Report a Bug", 
                       icon = icon("bug"),
         h4("Found a bug? Let us know."),
         textAreaInput("bug_text", "Describe the bug:", ""),
         actionButton("submit_bug", "Report")
)