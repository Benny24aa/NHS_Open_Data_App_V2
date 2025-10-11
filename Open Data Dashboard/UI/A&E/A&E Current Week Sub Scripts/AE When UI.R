AE_When_Source_UI <- conditionalPanel(
  condition= 'input.ae_recent_select == "Recent_AE_When_Tab"',
  
  uiOutput("currentAEHeadersummaryWhen"),
  
  div(
    style = "background-color: #cce5ff; padding: 15px; border-radius: 10px; margin-top: 15px;",
    fluidRow(
      column(3,div(class = "custom-select", selectInput("HBName_Current_AE_When", "Select Health Board", 
                                                        choices = unique(WeeklyAE_Healthboard$HBName)))),
      
      
      uiOutput("ae_department_type_when_filter"),
      
      
    ),# This ends the whole dashboard filters filter row
    
    br(),
    uiOutput("referral_boxes_when"),
    br(),
    
  ), ## end of division for summary boxes 
  br(),
 uiOutput("when_ae_title_graph_one"),
  br(),
  div(
    style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
    
    fluidRow(
      column(12,
             plotlyOutput("ae_ref_when_graph", height = "600px")
      )
    )
  ),### end of division graph 1
  
 br(),
 
 uiOutput("when_ae_title_graph_two"),
 br(),
 div(
   style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
   
   
   
   fluidRow(
     column(3,div(class = "custom-select-ae-graph", selectInput("When_AE_Week", "Select Weekends or Weekdays",
                                                       choices = unique(AE_When_Week$Week)))),
     
       # column(3,div(class = "custom-select-ae-graph", selectInput("InOut_AE_Week", "Select Out of Hours or In Hours",
       #                                                   choices = unique(AE_When_InOut$InOut))))
     uiOutput("ae_inout_type_when_filter"),
     
     uiOutput("ae_hour_when_filter"),
     
     ),
   
   fluidRow(
     column(12,
            plotlyOutput("ae_ref_hour_graph", height = "600px")
     )
   )
 ),
 br(),
 
 uiOutput("when_ae_title_graph_three"),
 
 br(),
 div(
   style = "background-color: #f0f0f0; padding: 20px; border-radius: 10px;",
   
   
   
   fluidRow(
     uiOutput("ae_month_when_filter_bar"),
     column(3,div(class = "custom-select-ae-graph", selectInput("When_AE_Week_Bar", "Select Weekends or Weekdays",
                                                                choices = unique(AE_When_Week$Week)))),
     
     uiOutput("ae_inout_type_when_filter_bar"),
     
     uiOutput("ae_hour_when_filter_bar"),
  
   ),
   
   fluidRow(
     column(12,
            plotlyOutput("ae_hour_when_barplot", height = "600px")
     )
   )
   
   
   ),
) # End of Conditional Panel