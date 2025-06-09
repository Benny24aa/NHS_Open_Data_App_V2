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
                                              h2("Cancer Incidence and Mortality Landing Page", style = "color:  #336699 ; font-weight: 600"))),
                                     
                                     fluidRow(
                                       column(6, actionButton("new_next", tags$b("New content and future updates"),
                                                              icon = icon('calendar-alt')))),
                                     
                                     fluidRow(
                                       column(12,
                                              
                                              h4(tags$b("Background Information", style = "color:  #336699 ; font-weight: 600" )),
                                              p("This dashboard shows annual data of new cancer incidence cases and deaths from cancer in Scotland. Data is presented by Health Boards within Scotland, the figures are further broken down by age group and sex.
The cancer sites reported on include: bladder, bone and connective tissue, brain and central nervous system, breast colorectal, female genital organs, head and neck, hodgkin lymphoma, kidney, leukaemias, liver, lung and mesothelioma, male genital organs, multiple myeloma, non-hodgkin lymphoma, oesophageal, pancreatic, skin, stomach."),
                                              
                                              h4(tags$b("Open Source Code Information" , style = "color:  #336699 ; font-weight: 600")),
                                              p("This GitHub repository contains the complete source code for an interactive web dashboard designed to visualize cancer incidence and mortality statistics across Healthboard."),
                                              
                                              p("If you wish to view the github for this dashboard please head to the following ", tags$a(href="https://github.com/Benny24aa/Scotland-Cancer-RShiny-Dashboard", icon("github"),
                                                                                                                                          "", target="_blank"), ), 
                                              h4(tags$b(" Disclosure and Data Security Statement", style = "color:  #336699 ; font-weight: 600")),
                                              p("All content is available under the Open Government License V3.0, and is available on NHS Scotland Open Data except where otherwise stated. If you need any assistance with this, please visit the UK Government Website for more information regarding the Open Government License. This dashboard is not a representive of the NHS and therefore is not an official source of information.")),
                                     )#End of Fluid Row
                                   ), #end of conditional panel
                                   
                                   conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Overview"',
                                     
                                     fluidRow(
                                       column(6,
                                              h2("Health Board Overview", style = "color:  #336699 ; font-weight: 600"))),
                                     h4("Health Board Overview for Cancer Incidence and Mortality Data provides a summary of cancer-related health outcomes across geographic health authority areas in Scotland. It offers key insights into the burden of cancer, how it varies by Health Board, and supports policy planning, resource allocation, and public health interventions. This page includes the ability to filter for different indicators such as Crude Rates and EASR and more for both Incidence and Mortality. Use the filters below to filter for all graphs on this page. "),
                                     
                                     
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
                                    
                                      uiOutput("Cancer_Overview"),
                                     fluidRow(
                                       column(3, plotlyOutput("scotland_info_graph_server", width = "400%", height = "600px"))),
                                     uiOutput("Cancer_Sex_Overview"),
                                     fluidRow(
                                       column(3, plotlyOutput("scotland_gender_graph_server", width = "400%", height = "600px")))
                                     
                                     
                                   ), # end of conditional panel
                                   
                                   conditionalPanel(
                                     condition= 'input.cancer_dashboard_select == "Cancer_Comparison"',
                                     

  fluidRow(
    column(6,
           h2("Health Board Comparison", style = "color:  #336699 ; font-weight: 600"))),
  h4("Health Board Comparison for Cancer Incidence and Mortality Data provides the user the ability to compare Health Boards using different incidators such as EASR and Crude Rates. Please use the filters above the graph to aid you. Click on the legend on the side of the graph to keep or remove Health Boards at your leisure. "),
  

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
         h2("Health Board Statistics", style = "color:  #336699 ; font-weight: 600"))),
h4("This dashboard provides a comparative overview of key cancer statistics across Health Boards. It features two interactive visualizations which are a Scatter Plot which displays individual Health Boards as data points, allowing comparison of specific cancer indicators (e.g., incidence, and mortality) by Healthboard. This helps identify outliers or trends across boards.
The other visual is a Box Plot, which summarises the distribution of the same indicators, highlighting medians, quartiles, and any statistical outliers. This gives a clearer view of overall variation and equity in health outcomes.
Use the dropdown filters to customize the view by cancer type, data type (e.g., crude rate, age-standardized rate), and demographic grouping (sex)."),

  
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
uiOutput("Cancer_ScatterPlot_Text"),
  fluidRow(
    column(3, plotlyOutput("hb_cancer_outlier", width = "400%", height = "600px"))),
uiOutput("Cancer_boxplot_Text"),
   fluidRow(
  column(3, selectInput("BoxPlot_Input_Cancer", label = "Select Data Type",
                        choices = unique(GraphTypeOptionsStatsCancer$Graph_Types_Stats_Cancer,
                                         multiple = TRUE)))),
  fluidRow(
    column(3, plotlyOutput("hb_cancer_outlier_box", width = "400%", height = "600px")))
  
  
)
                                   
                                   
                         ))) #End of TabPanel