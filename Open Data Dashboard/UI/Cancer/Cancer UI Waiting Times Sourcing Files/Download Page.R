Cancer_Waiting_Times_Download_Page <- conditionalPanel(
  condition= 'input.cancer_waiting_time_select == "Cancer_Waiting_Times_Download"',
  
  h2("Select the dataset you wish to download", style = "color: #336699 ; font-weight: 600"),
  p("This section allows you to view error data in table format. You can use the filters to select the data you're interested in and download it into a csv format using the download button."),
  column(6, selectInput("cancer_waiting_list_download_select", "Select the data you want to explore.",
                        choices = cancer_waiting_list_download_list)),
  mainPanel(width = 12,
            DT::dataTableOutput("data_download_cancer_waiting_list_table_filtered")),
  column(6, downloadButton('download_table_csv_waiting_list', 'Download data')),
)