# NHS Scotland Open Data Application

* This is an application that I have built in my personal time. The R shiny app will be available to the public soon.
* The data underlying the app can be found on the [PHS open data website (external link)](https://www.opendata.nhs.scot/)

# Features

* Interactive Dashboards: Explore various NHS datasets through dynamic charts and tables.
* Data Filtering: Apply filters to drill down into specific data points.
* Responsive Design: Optimized for both desktop and mobile devices.
* Data Export: Download datasets for offline analysis.

# Installation - Prerequisites

* R (version 4.0.0 or higher)
* RStudio (recommended)
* Required R packages (see requirements.txt)

# Usage

Upon launching the app, users are presented with a dashboard containing various tabs:
* Home: Introduction and instructions.
* Data Visualization: Interactive charts and graphs.
* Data Export: Option to download datasets.

# Deploying or Using Dashboard

1. Clone the repository
```bash
git clone https://github.com/Benny24aa/NHS_Open_Data_App_V2.git
cd NHS_Open_Data_App_V2
```
2. Open the R Project
If you’re using RStudio:
```bash
open NHS_Open_Data_App_V2.Rproj  # macOS
# or use RStudio to open the .Rproj file on Windows/Linux
```
3. Run the Shiny App
Start R in the project directory and run:
```bash
Rscript -e "shiny::runApp('Open Data Dashboard')"
```
4. Install Required Packages (if needed)
Make sure you have the required R packages installed:
```bash
install.packages(c("shiny", "dplyr", "ggplot2", "plotly", "DT"))
```

# App code layout

* The Shiny App contains an Main UI, Server and Global File which sources in mulitple smaller files where necessary
* `www` contains static images as well as additional css and javascript code
* 'Overview Graphs' Server File contains all plotly graphs which are called upon by the UI
* 'Interactive Text' Server File contains all the text which is called upon by the UI that has filters applied
*  Other Server Files contain smaller pieces of code which allows users to download data from the dashboard and server files relating to commentary and metadata.
*  UI files are split into different folders based on their category
*  Global files are split into different folders based on their category

# Contributing

Contributions are welcome! Please fork the repository, create a new branch, and submit a pull request with your proposed changes.

# License

This project is licensed under the MIT License.



