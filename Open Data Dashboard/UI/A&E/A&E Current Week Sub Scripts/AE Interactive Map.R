AE_Interactive_Map <- tabPanel(title = "Interactive Map", 
                       icon = icon("map"),
                       
                       HTML(paste0(
                         paste("<div style='color: #336699; font-size: 24px; font-weight: bold;'>",
                               "Interactive Map of Accident and Emergency Rates Across Scotland"),
                         "</div>"
                       )),
                       
                       # Styled section: filters + value boxes
                       div(
                         style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
                         
                         fluidRow(
                           
                           column(3,
                                  div(class = "custom-select",
                                      selectInput("AttendanceCategory_Map_AE", "Select Category", 
                                                  choices = unique(WeeklyAE_Healthboard$AttendanceCategory)))
                           ),
                           
                           column(3, 
                                  div(class = "custom-select", selectInput(
                                    inputId = "ae_map_measure_select",
                                    label = "Select Measure",
                                    choices = c(
                                      "Total Attendances" = "TotalAttendances",
                                      "Over 4 Hours" = "TotalOver4Hours",
                                      "Over 8 Hours" = "TotalOver8Hours",
                                      "Over 12 Hours" = "TotalOver12Hours",
                                      "Within 4 Hours" = "TotalWithin4Hours"
                                    ),
                                    selected = "TotalAttendances"
                                  ))
                           ),
                           
                           column(3,
                                  div(class = "custom-select",
                                      selectInput("Date_Map_AE", "Select Date", 
                                                  choices = unique(Weeks_AE_Map$WeekEndingDate)))
                           
                           )
                         ),
                         
                      
                       ), ## end of division
                   
                       
                     #  uiOutput("template"),

                       
                       div(
                         style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",

                         fluidRow(
                           column(12,
                                  leafletOutput("ae_leaflet_map", height = "600px")
                           )
                         )
                       )
                       
                       
                       
                       ) # End of Panel