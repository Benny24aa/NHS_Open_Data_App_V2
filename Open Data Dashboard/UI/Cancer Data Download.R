cancer_data_download <- tabPanel(title = "Cancer Data Download", icon = icon('table'),
                                    h2("Select the dataset you wish to download", style = "color: #336699 ; font-weight: 600"),
                                    p("This section allows you to view error data in table format. You can use the filters to select the data you're interested in and download it into a csv format using the download button."),
                                    column(6, selectInput("cancer_download_select", "Select the data you want to explore.",
                                                          choices = Cancer_Download_List)),
                                    mainPanel(width = 12,
                                              DT::dataTableOutput("data_download_cancer_table_filtered")),
                                    column(6, downloadButton('download_table_csv', 'Download data')),
) 