# NEW CONTENT AND FUTURE UPDATES INFO BUTTON - INFO PAGE ----

observeEvent(input$new_next,
             showModal(modalDialog( # creates a modal: a pop-up box that contains text information
               title = "New content added and future updates",
               h4("Future updates"),
               tags$ul(
                 tags$li(""),
                 tags$li(""),
                 tags$li(""),
                 tags$li(""),
                 tags$li(""),
                 tags$li("")),
               size = "m",
               easyClose = TRUE, fade=FALSE,footer = modalButton("Close (Esc)"))))