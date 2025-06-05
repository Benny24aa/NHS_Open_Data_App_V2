Commentary <- tabPanel(title = "Metadata and Commentary", 
                       
                       
                       sidebarLayout(
                         sidebarPanel(width = 3,
                                      radioGroupButtons("com_select",
                                                        choices = com_list, status = "primary",
                                                        direction = "vertical", justified = T)),
                         mainPanel(width = 9,
                                   
                                   
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "Cancer_Mortality_Section"',
                                     
                                     p(h3("Dataset Purpose", style = "color:  #336699 ; font-weight: 600")),
                                     h4("This dataset provides detailed statistics on cancer mortality across Scotland, enabling health professionals and policymakers to:"),
                                     tags$ul(
                                       tags$li("Monitor trends in cancer-related deaths over time."),
                                       tags$li("Identify disparities in cancer mortality rates across different health boards."),
                                       tags$li("Assess the effectiveness of public health interventions and cancer control programs."),
                                       tags$li("Support research and planning for cancer services and resource allocation.")),
                                     
                                     p(h3("Additional Information", style = "color:  #336699 ; font-weight: 600")),
                                     tags$ul(
                                       tags$li("Time Frame of Data and Timeliness: Data is presented annually, with updates reflecting the most recent complete year of data."),
                                       tags$li("Data Frequency: Annual"),
                                       tags$li("Disclosure: The dataset adheres to the Public Health Scotland Statistical Disclosure Protocol to ensure confidentiality and data protection."),
                                       tags$li("Official Statistics Designation: National Statistics"),
                                       tags$li("Relevance and Key Uses of the Statistics: The dataset is crucial for understanding cancer mortality patterns, guiding public health strategies, and informing cancer research and policy development.")),
                                     
                                     
                                     p(h3("Dataset Overview", style = "color:  #336699 ; font-weight: 600")),
                                     tags$ul(
                                       tags$li("Title: Cancer Mortality – Mortality by Health Board"),
                                       tags$li("Resource ID: 57f0983f-864e-4dbd-b3dc-ea8f16de83a4"),
                                       tags$li("Last Modified: 3 months ago"),
                                       tags$li("Created: February 12, 2019"),
                                       tags$li("Metadata Last Updated: February 12, 2019"),
                                       tags$li("License: UK Open Government License (OGL)"),
                                       tags$li("Data Last Updated: February 25, 2025")),
                                     
                                     
                                     p(h3("Dataset Dictionary", style = "color:  #336699 ; font-weight: 600")),
                                     h4("The dataset includes the following columns:"),
                                     fluidRow(
                                       column(12,
                                              dataTableOutput('cancer_mortality_metadata_table')
                                       )
                                     ) 
                                
                                     
                                   ), #end of conditional panel
                                   
                                   
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "Cancer_Incidence_Section"',
                                     
                                     p(h3("Dataset Purpose", style = "color:  #336699 ; font-weight: 600")),
                                     h4("This dataset provides detailed statistics on new cancer registrations across Scotland, enabling health professionals and policymakers to:"),
                                     tags$ul(
                                       tags$li("Monitor trends in cancer over time."),
                                       tags$li("Identify disparities in cancer incidence rates across different health boards."),
                                       tags$li("Assess the effectiveness of public health interventions and cancer control programs."),
                                       tags$li("Support research and planning for cancer services and resource allocation.")),
                                     
                                     p(h3("Additional Information", style = "color:  #336699 ; font-weight: 600")),
                                     tags$ul(
                                       tags$li("Time Frame of Data and Timeliness: Data is presented annually, with updates reflecting the most recent complete year of data."),
                                       tags$li("Data Frequency: Annual"),
                                       tags$li("Disclosure: The dataset adheres to the Public Health Scotland Statistical Disclosure Protocol to ensure confidentiality and data protection."),
                                       tags$li("Official Statistics Designation: National Statistics"),
                                       tags$li("Relevance and Key Uses of the Statistics: The dataset is crucial for understanding cancer incidence patterns, guiding public health strategies, and informing cancer research and policy development.")),
                                     
                                     
                                     p(h3("Dataset Overview", style = "color:  #336699 ; font-weight: 600")),
                                     tags$ul(
                                       tags$li("Title: Annual Cancer Incidence – Incidence by Health Board"),
                                       tags$li("Resource ID: 3aef16b7-8af6-4ce0-a90b-8a29d6870014"),
                                       tags$li("Last Modified: 3 months ago"),
                                       tags$li("Created: February 6, 2019"),
                                       tags$li("Metadata Last Updated: February 6, 2019"),
                                       tags$li("License: UK Open Government License (OGL)"),
                                       tags$li("Data Last Updated: March 28, 2023")),
                                     
                                     
                                     p(h3("Dataset Dictionary", style = "color:  #336699 ; font-weight: 600")),
                                     h4("The dataset includes the following columns:"),
                                     fluidRow(
                                       column(12,
                                              dataTableOutput('cancer_incidence_metadata_table')
                                       )
                                     ) 
                                     
                                     
                                   ), #end of conditional panel
                                   
                                   
                                   
                                   
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "Cancer_Waiting_List_Section"',
                                     p(h3("27/04/2025")),
                                     h4("Cancer Waiting List Commentary"),
                                     tags$ul(
                                       tags$li(""))
                                   ) # end of conditional panel
                                   
                                   
                         ))) #End of TabPanel