##### Big GP list - Bringing in all Practice Size Lists over the years
##### Using httr::GET() to avoid Windows schannel TLS errors

library(httr)
library(jsonlite)
library(readr)
library(dplyr)
library(purrr)
library(stringr)
library(lubridate)
library(tidyr)

dataset_id <- "f23655c3-6e23-4103-a511-a80d998adb90"

api_url <- paste0(
  "https://www.opendata.nhs.scot/api/3/action/package_show?id=",
  dataset_id
)

# ---- Fetch metadata ----
res <- httr::GET(api_url)
httr::stop_for_status(res)

meta <- httr::content(res, as = "text", encoding = "UTF-8") |>
  jsonlite::fromJSON(flatten = TRUE)

resources <- meta$result$resources

# ---- Keep only GP CSV files ----
csv_resources <- resources |>
  dplyr::filter(grepl("csv", format, ignore.case = TRUE)) |>
  dplyr::filter(grepl("GP", name, ignore.case = TRUE))

# ---- Extract Month + Year from file name ----
extract_date_info <- function(name) {
  
  match <- stringr::str_extract(
    name,
    "(January|February|March|April|May|June|July|August|September|October|November|December)\\s+\\d{4}"
  )
  
  if (is.na(match)) {
    return(tibble(
      month = NA_character_,
      year  = NA_integer_,
      date  = as.Date(NA)
    ))
  }
  
  date_parsed <- lubridate::my(match)
  
  tibble(
    month = month(date_parsed, label = TRUE, abbr = FALSE),
    year  = year(date_parsed),
    date  = date_parsed
  )
}

csv_resources <- csv_resources |>
  mutate(date_info = purrr::map(name, extract_date_info)) |>
  unnest(date_info) |>
  filter(!is.na(date)) |>
  arrange(date)


cat("Number of GP files to download:", nrow(csv_resources), "\n")

# ---- Safe downloader using httr ----
safe_read_csv <- function(url) {
  
  tryCatch({
    
    response <- httr::GET(url)
    httr::stop_for_status(response)
    
    readr::read_csv(
      httr::content(response, as = "raw"),
      col_types = cols(.default = col_character()),
      show_col_types = FALSE
    )
    
  }, error = function(e) {
    
    message("Failed to download: ", url)
    return(NULL)
    
  })
}

# ---- Download all files safely ----
data_list <- purrr::map2(
  csv_resources$url,
  csv_resources$date,
  function(url, date_value) {
    
    df_temp <- safe_read_csv(url)
    
    if (is.null(df_temp)) return(NULL)
    
    df_temp |>
      mutate(
        month = month(date_value, label = TRUE, abbr = FALSE),
        year  = year(date_value),
        date  = date_value
      )
  }
)

# ---- Remove failed downloads ----
data_list <- purrr::compact(data_list)

# ---- Combine all GP lists ----
all_gp_data <- dplyr::bind_rows(data_list)

cat("Final combined GP list rows:", nrow(big_gp_list), "\n")