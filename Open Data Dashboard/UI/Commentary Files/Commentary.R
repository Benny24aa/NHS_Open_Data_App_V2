Commentary <- tabPanel(title = "Metadata and Commentary", 
                       
                      
                       
                       sidebarLayout(
                         sidebarPanel(width = 3,
                                      radioGroupButtons("com_select",
                                                        choices = com_list, status = "primary",
                                                        direction = "vertical", justified = T)),
                         mainPanel(width = 9,
                                   
                             
                                   
                                 fluidRow(column(6, uiOutput("dynamic_title_metadata_commentary")),
                                          column(6,  radioButtons("metadata_commentary_switch", 
                                                                  label = "View", 
                                                                  choices = c("Metadata", "Commentary"), 
                                                                  selected = "Metadata", 
                                                                  inline = TRUE,
                                                                  width = '100%'),  # Full width, can adjust as needed )
                                            )),
                                  
                                   
                                   
                                   conditionalPanel(
                                     condition = 'input.com_select == "Cancer_Mortality_Section" && input.metadata_commentary_switch == "Metadata"',
                                     
          
                                     p(h3("Dataset Purpose", style = "color:  #336699 ; font-weight: 600; margin-top: 0;")),
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
                                   condition = 'input.com_select == "Cancer_Mortality_Section" && input.metadata_commentary_switch == "Commentary"',
                                   
                                   
                                   p(h3("Commentary", style = "color:  #336699 ; font-weight: 600; margin-top: 0;")),
                                   h4(""),
                                   tags$ul(
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li("")),
                                   
                    
                                   p(h3("Future Developments", style = "color:  #336699 ; font-weight: 600")),
                                   tags$ul(
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""))
                                   
                                   
                                 
                                   
                                   
                                 ), #end of conditional panel
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                   
                                   
                                   
                                   conditionalPanel(
                                     condition = 'input.com_select == "Cancer_Incidence_Section" && input.metadata_commentary_switch == "Metadata"', 
                                     
                                     p(h3("Dataset Purpose", style = "color:  #336699 ; font-weight: 600; margin-top: 0;")),
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
                                       tags$li("Created: February 6, 2019"),
                                       tags$li("Metadata Last Updated: February 6, 2019"),
                                       tags$li("License: UK Open Government License (OGL)"),
                                       tags$li("Data Last Updated: November 26, 2024")),
                                     
                                     
                                     p(h3("Dataset Dictionary", style = "color:  #336699 ; font-weight: 600")),
                                     h4("The dataset includes the following columns:"),
                                     fluidRow(
                                       column(12,
                                              dataTableOutput('cancer_incidence_metadata_table')
                                       )
                                     ) 
                                     
                                     
                                   ), #end of conditional panel
                                   
                                 conditionalPanel(
                                   condition = 'input.com_select == "Cancer_Incidence_Section" && input.metadata_commentary_switch == "Commentary"',
                                   
                                   
                                   p(h3("Commentary", style = "color:  #336699 ; font-weight: 600; margin-top: 0;")),
                                   h4(""),
                                   tags$ul(
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li("")),
                                   
                                   
                                   p(h3("Future Developments", style = "color:  #336699 ; font-weight: 600")),
                                   tags$ul(
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""))
                                   
                                   
                                   
                                   
                                   
                                 ), #end of conditional panel
                                 
                                   
                                   
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "Cancer_Waiting_List_31_Day_Section" && input.metadata_commentary_switch == "Metadata"',
                                     p(h3("Dataset Purpose", style = "color:  #336699 ; font-weight: 600; margin-top: 0;")),
                                     h4("This dataset provides detailed statistics on cancer treatment waiting times across Scotland, specifically focused on the national 31-Day Standard. It is designed to help:"),
                                     tags$ul(
                                       tags$li("Monitor how quickly patients begin cancer treatment after a decision to treat has been made."),
                                       tags$li("Evaluate performance across different NHS Health Boards."),
                                       tags$li("Identify areas of delay or variation in access to treatment."),
                                       tags$li("Support evidence-based resource allocation, service planning, and policy development.")),
                                     
                                     p(h3("Additional Information", style = "color:  #336699 ; font-weight: 600")),
                                     tags$ul(
                                       tags$li("Time Frame of Data and Timeliness: Data is reported quarterly and reflects the most recent complete reporting period available. "),
                                       tags$li("Data Frequency: Quarterly"),
                                       tags$li("Disclosure: This dataset complies with the Public Health Scotland Statistical Disclosure Protocol to protect patient confidentiality. "),
                                       tags$li("Official Statistics Designation: National Statistics"),
                                       tags$li("Relevance and Key Uses of the Statistics: Informing the public, stakeholders, and researchers on how well treatment targets are being met. ")),
                                     
                                     
                                     p(h3("Dataset Overview", style = "color:  #336699 ; font-weight: 600")),
                                     tags$ul(
                                       tags$li("Title: Cancer Waiting Times (31-Day Standard)"),
                                       tags$li("Resource ID: 58527343-a930-4058-bf9e-3c6e5cb04010"),
                                       tags$li("Created: July 6, 2018 "),
                                       tags$li("Metadata Last Updated: July 6, 2018 "),
                                       tags$li("License: UK Open Government License (OGL)"),
                                       tags$li("Data Last Updated: 26 March 2025")),
                                     
                                     
                                     p(h3("Dataset Dictionary", style = "color:  #336699 ; font-weight: 600")),
                                     h4("The dataset includes the following columns:"),
                                     fluidRow(
                                       column(12,
                                              dataTableOutput('cancer_31day_metadata_table')
                                       )
                                     )
                                   ), # end of conditional panel
                                 
                                 
                                 
                                 conditionalPanel(
                                   condition = 'input.com_select == "Cancer_Waiting_List_31_Day_Section"  && input.metadata_commentary_switch == "Commentary"',
                                   
                                   
                                   p(h3("Commentary", style = "color:  #336699 ; font-weight: 600; margin-top: 0;")),
                                   h4(""),
                                   tags$ul(
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li("")),
                                   
                                   
                                   p(h3("Future Developments", style = "color:  #336699 ; font-weight: 600")),
                                   tags$ul(
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""))
                                   
                                   
                                   
                                   
                                   
                                 ), #end of conditional panel
                                 
                                 
                  
                                   
                                   conditionalPanel(
                                     condition= 'input.com_select == "Cancer_Waiting_List_62_Day_Section" && input.metadata_commentary_switch == "Metadata"',
                                     p(h3("Dataset Purpose", style = "color:  #336699 ; font-weight: 600; margin-top: 0;")),
                                     h4("This dataset provides detailed statistics on cancer treatment waiting times across Scotland, specifically focused on the national 62-Day Standard. It is designed to help:"),
                                     tags$ul(
                                       tags$li("Monitor how quickly patients begin cancer treatment after a decision to treat has been made."),
                                       tags$li("Evaluate performance across different NHS Health Boards."),
                                       tags$li("Identify areas of delay or variation in access to treatment."),
                                       tags$li("Support evidence-based resource allocation, service planning, and policy development.")),
                                     
                                     p(h3("Additional Information", style = "color:  #336699 ; font-weight: 600")),
                                     tags$ul(
                                       tags$li("Time Frame of Data and Timeliness: Data is reported quarterly and reflects the most recent complete reporting period available. "),
                                       tags$li("Data Frequency: Quarterly"),
                                       tags$li("Disclosure: This dataset complies with the Public Health Scotland Statistical Disclosure Protocol to protect patient confidentiality. "),
                                       tags$li("Official Statistics Designation: National Statistics"),
                                       tags$li("Relevance and Key Uses of the Statistics: Informing the public, stakeholders, and researchers on how well treatment targets are being met. ")),
                                     
                                     
                                     p(h3("Dataset Overview", style = "color:  #336699 ; font-weight: 600")),
                                     tags$ul(
                                       tags$li("Title: Cancer Waiting Times (62-Day Standard)"),
                                       tags$li("Resource ID: 23b3bbf7-7a37-4f86-974b-6360d6748e08"),
                                       tags$li("Created: July 6 2018 "),
                                       tags$li("Metadata Last Updated: July 6 2018 "),
                                       tags$li("License: UK Open Government License (OGL)"),
                                       tags$li("Data Last Updated: 26 March 2025")),
                                     
                                     
                                     p(h3("Dataset Dictionary", style = "color:  #336699 ; font-weight: 600")),
                                     h4("The dataset includes the following columns:"),
                                     fluidRow(
                                       column(12,
                                              dataTableOutput('cancer_62day_metadata_table')
                                       )
                                     )
                                   ), # end of conditional panel
                                 
                                 conditionalPanel(
                                   condition = 'input.com_select == "Cancer_Waiting_List_62_Day_Section"  && input.metadata_commentary_switch == "Commentary"',
                                   
                                   
                                   p(h3("Commentary", style = "color:  #336699 ; font-weight: 600; margin-top: 0;")),
                                   h4(""),
                                   tags$ul(
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li("")),
                                   
                                   
                                   p(h3("Future Developments", style = "color:  #336699 ; font-weight: 600")),
                                   tags$ul(
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""),
                                     tags$li(""))
                                   
                                   
                                   
                                   
                                   
                                 ) #end of conditional panel
                                   
                                   
                         ))) #End of TabPanel

