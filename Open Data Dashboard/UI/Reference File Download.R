reference_file_download <- tabPanel(title = "Reference Files", icon = icon('table'),
                          h2("Select the dataset you wish to download", style = "color: #336699 ; font-weight: 600"),
                          p("This section allows you to view error data in table format. You can use the filters to select the data you're interested in and download it into a csv format using the download button."),
                          column(6, selectInput("download_select", "Select the data you want to explore.",
                                                choices = reference_file_download_list)),
                          mainPanel(width = 12,
                                    DT::dataTableOutput("data_download_table_filtered")),
                          column(6, downloadButton('download_table_csv', 'Download data')),
) 