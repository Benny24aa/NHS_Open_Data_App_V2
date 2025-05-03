Cancer_UI_Setup <- tabPanel(title = "Mortality and Incidence",  icon = icon("disease"),
                       
                       
                       sidebarLayout(
                         sidebarPanel(width = 2,
                                      radioGroupButtons("cancer_dashboard_select",
                                                        choices = cancer_dashboards, status = "primary",
                                                        direction = "vertical", justified = T)),
                         mainPanel(width = 10,
                                   

                                   conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Landing_Page"',
                                     
                                     fluidRow(
                                       column(6,
                                              h2("Welcome to the Scottish Open Data Cancer Dashboard", style = "color:  #336699 ; font-weight: 600"))),
                                     
                                     fluidRow(
                                       column(6, actionButton("new_next", tags$b("New content and future updates"),
                                                              icon = icon('calendar-alt')))),
                                     
                                     fluidRow(
                                       column(12,
                                              h4(tags$b("?" , style = "color:  #336699 ; font-weight: 600")),
                                              p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/Scotland-Cancer-RShiny-Dashboard", icon("github"),
                                                                                                                                          "", target="_blank"), ), 
                                              h4(tags$b("?", style = "color:  #336699 ; font-weight: 600" )),
                                              p(""),
                                              h4(tags$b(" Disclosure and Data Security Statement", style = "color:  #336699 ; font-weight: 600")),
                                              p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information.")),
                                     )#End of Fluid Row
                                   ), #end of conditional panel
                                   
                                   conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Overview"',
                                     
                                     fluidRow(
                                       column(6,
                                              h2("Health Board Overview", style = "color:  #336699 ; font-weight: 600"))),
                                     
                                     fluidRow(
                                       
                                       column(3, selectInput("hb_name", label = "Select Healthboard",
                                                             choices = unique(HB_List$HBName,
                                                                              multiple = FALSE))),
                                       column(3, selectInput("datatype_input", label = "Select data you wish to view",
                                                             choices = unique(Cancer_Data_Type$DataType,
                                                                              multiple = TRUE))),
                                       
                                       column(3, selectInput("graphtype_input", label = "Select statistical graph type",
                                                             choices = unique(GraphTypeOptions$Graph_Types,
                                                                              multiple = TRUE))),
                                       
                                       column(3, selectInput("Cancer_Type_Input", label = "Select the cancer type you wish to explore",
                                                             choices = unique(cancer_types$CancerSite,
                                                                              multiple = TRUE)))),
                                     
                                     fluidRow(
                                       column(3, plotlyOutput("scotland_info_graph_server", width = "400%", height = "600px"))),
                                     fluidRow(
                                       column(3, plotlyOutput("scotland_gender_graph_server", width = "400%", height = "600px")))
                                     
                                     
                                   ), # end of conditional panel
                                   
                                   conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Comparison"',
                                     
                                     fluidRow(
  column(6,
         h2("Health Board Comparison", style = "color:  #336699 ; font-weight: 600"))),

fluidRow(
 
  
column(3, selectInput("datatype_input_compare", label = "Select data you wish to view",
                      choices = unique(Cancer_Data_Type$DataType,
                                       multiple = TRUE))),

column(3, selectInput("graphtype_input_compare", label = "Select statistical graph type",
                      choices = unique(GraphTypeOptions$Graph_Types,
                                       multiple = TRUE))),

column(3, selectInput("Cancer_Type_Input_compare", label = "Select the cancer type you wish to explore",
                      choices = unique(cancer_types$CancerSite,
                                       multiple = TRUE)))



),

fluidRow(
  column(3, plotlyOutput("hb_compare_graph", width = "400%", height = "600px")))



                                   ), #end of conditional panel
                                  
                                    conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Download_Data"',
                                     
                                     h2("Select the dataset you wish to download", style = "color: #336699 ; font-weight: 600"),
                                     p("This section allows you to view error data in table format. You can use the filters to select the data you're interested in and download it into a csv format using the download button."),
                                     column(6, selectInput("cancer_download_select", "Select the data you want to explore.",
                                                           choices = Cancer_Download_List)),
                                     mainPanel(width = 12,
                                               DT::dataTableOutput("data_download_cancer_table_filtered")),
                                     column(6, downloadButton('download_table_csv', 'Download data')),
                                   ),#end of conditional panel


conditionalPanel(
  condition= 'input.cancer_dashboard_select == "Cancer_Statistics"',
  
  fluidRow(
    column(6,
           h2("Health Board Overview", style = "color:  #336699 ; font-weight: 600"))),
  
  fluidRow(
    
    column(3, selectInput("hb_name", label = "Select Healthboard",
                          choices = unique(HB_List$HBName,
                                           multiple = FALSE))),
    
    column(3, selectInput("Cancer_Type_Input_Stats", label = "Select the cancer type you wish to explore",
                          choices = unique(cancer_types$CancerSite,
                                           multiple = TRUE))),
  
  column(3, selectInput("Cancer_Gender_Input", label = "Select Gender",
                        choices = unique(Cancer_Genders$Sex,
                                         multiple = TRUE)))),
  
  fluidRow(
    column(3, plotlyOutput("hb_cancer_outlier", width = "400%", height = "600px"))),
 
   fluidRow(
  column(3, selectInput("BoxPlot_Input_Cancer", label = "Select Data Type",
                        choices = unique(GraphTypeOptionsStatsCancer$Graph_Types_Stats_Cancer,
                                         multiple = TRUE)))),
  
  fluidRow(
    column(3, plotlyOutput("hb_cancer_outlier_box", width = "400%", height = "600px")))
  
  
)
                                   
                                   
                         ))) #End of TabPanel