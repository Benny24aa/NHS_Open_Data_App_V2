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

# Contributing

Contributions are welcome! Please fork the repository, create a new branch, and submit a pull request with your proposed changes.

# License

This project is licensed under the MIT License.

### App code layout

* The Shiny App contains an Main UI, Server and Global File which sources in mulitple smaller files where necessary
* `www` contains static images as well as additional css and javascript code
* 'Overview Graphs' Server File contains all plotly graphs which are called upon by the UI
* 'Interactive Text' Server File contains all the text which is called upon by the UI that has filters applied
*  Other Server Files contain smaller pieces of code which allows users to download data from the dashboard and server files relating to commentary and metadata.
*  UI files are split into different folders based on their category
*  Global files are split into different folders based on their category

```bash
RShiny -R
```


