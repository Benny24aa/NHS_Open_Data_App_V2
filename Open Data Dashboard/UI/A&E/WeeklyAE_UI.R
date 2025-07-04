WeeklyAEUI <- tabPanel(title = "Weekly Accident and Emergency Statistics", 
                        icon = icon("ambulance"),
                       
                       fluidRow(
                         column(6,
                                h2("Accident and Emergency Statistics", style = "color:  #336699 ; font-weight: 600"))),
                       h4("Soon"),

                       fluidRow(
                         
                         column(3, selectInput("hb_name_ae", label = "Select Healthboard",
                                               choices = unique(HB_List$HBName,
                                                                multiple = FALSE))),
                         
                         column(3, uiOutput("accident_emergency_hospital_filter")),
                       
                         
                         column(3, selectInput("attendance_category_ae_input", label = "Select Diagnostic Type",
                                               choices = unique(Attendance_Category_AE_List$AttendanceCategory,
                                                                multiple = FALSE))),
                         
                       )
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       ) # End of tabPanel