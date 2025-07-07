WeeklyAEUI <- tabPanel(title = "Historical Weekly Accident and Emergency Statistics", 
                        icon = icon("ambulance"),
                       
                       fluidRow(
                         column(6,
                                h2("Historical Accident and Emergency Statistics", style = "color:  #336699 ; font-weight: 600"))),
                       h4("This dashboard provides an interactive overview of the Accident & Emergency (A&E) system across Scotland. Users can explore patterns and trends in activity across different health boards, hospital sites, and years. The visualisations offer insights into how demand and performance have changed over time, helping identify areas of pressure and variation across the country.

By comparing recent data with historical trends, the dashboard supports a better understanding of the A&E landscape, aiding planning, evaluation, and decision-making at both local and national levels."),

                       fluidRow(
                         
                         column(3, selectInput("hb_name_ae", label = "Select Healthboard",
                                               choices = unique(HB_List$HBName,
                                                                multiple = FALSE))),
                         
                         column(3, uiOutput("accident_emergency_hospital_filter")),
                       
                         
                         column(3, selectInput("attendance_category_ae_input", label = "Select Diagnostic Type",
                                               choices = unique(Attendance_Category_AE_List$AttendanceCategory,
                                                                multiple = FALSE))),
                         column(3, selectInput(
                           inputId = "ae_year_input",
                           label = "Select Year",
                           choices = sort(2015:2025, decreasing = TRUE), 
                           selected = 2025,
                           multiple = FALSE
                         ))
                         
                       ),
                       br(), 
                       fluidRow(
                         column(6,
                                h3("Number of attendances", style = "color:  #336699 ; font-weight: 600"),
                                withSpinner(plotlyOutput("total_weekly_ae_attendance_graph", height = "600px")), type = 4, color = "blue", size = 1.5),
                         column(6, 
                                h3("Number of people seen in over 4 Hours", style = "color:  #336699 ; font-weight: 600"),
                                withSpinner(plotlyOutput("total_weekly_ae_over_four_hours_graph", height = "600px")), type = 4, color = "blue", size = 1.5),
                       ),
                       br(), 
                       fluidRow(
                         column(6,
                                h3("Number of people seen within 4 hours", style = "color:  #336699 ; font-weight: 600"),
                                withSpinner(plotlyOutput("total_weekly_ae_within_four_hours_graph", height = "600px")), type = 4, color = "blue", size = 1.5),
                         column(6,
                                h3("Percentage of the number of people seen within 4 hours", style = "color:  #336699 ; font-weight: 600"),
                                withSpinner(plotlyOutput("total_weekly_ae_within_four_hours_percentage_graph", height = "600px")), type = 4, color = "blue", size = 1.5),
                       ),
                       br(), 
                       fluidRow(
                         column(6,
                                h3("Number of people seen in over 8 hours", style = "color:  #336699 ; font-weight: 600"),
                                withSpinner(plotlyOutput("total_weekly_ae_over_eight_hours_graph", height = "600px")), type = 4, color = "blue", size = 1.5),
                         column(6,
                                h3("Percentage of the number of people seen over 8 hours", style = "color:  #336699 ; font-weight: 600"),
                                withSpinner(plotlyOutput("total_weekly_ae_over_eight_hours_percentage_graph", height = "600px")), type = 4, color = "blue", size = 1,5),
                       ),
                       
                       
                       br(), 
                       fluidRow(
                         column(6,
                                h3("Number of people seen in over 12 hours", style = "color:  #336699 ; font-weight: 600"),
                                withSpinner(plotlyOutput("total_weekly_ae_over_twelve_hours_graph", height = "600px")), type = 4, color = "blue", size = 1.5),
                         column(6,
                                h3("Percentage of the number of people seen over 12 hours", style = "color:  #336699 ; font-weight: with600"),
                                withSpinner(plotlyOutput("total_weekly_ae_over_twelve_hours_percentage_graph", height = "600px")), type = 4, color = "blue", size = 1.5)
                       )
                      
                       
                       
        
                     
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       ) # End of tabPanel