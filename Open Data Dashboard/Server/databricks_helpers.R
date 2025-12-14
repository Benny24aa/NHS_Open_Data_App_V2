library(httr)
library(jsonlite)

get_warehouse_status <- function(databricks_host, warehouse_id, token) {
  res <- GET(
    paste0("https://", databricks_host, "/api/2.0/sql/warehouses/", warehouse_id),
    add_headers(Authorization = paste("Bearer", token))
  )
  if (status_code(res) != 200) stop("Failed to get warehouse status")
  content(res)$state
}

start_warehouse_if_needed <- function(databricks_host, warehouse_id, token) {
  status <- get_warehouse_status(databricks_host, warehouse_id, token)
  if (status == "RUNNING") return(invisible(TRUE))
  
  POST(
    paste0("https://", databricks_host, "/api/2.0/sql/warehouses/", warehouse_id, "/start"),
    add_headers(Authorization = paste("Bearer", token))
  )
  
  repeat {
    Sys.sleep(10)
    status <- get_warehouse_status(databricks_host, warehouse_id, token)
    if (status == "RUNNING") break
  }
  invisible(TRUE)
}

execute_query <- function(sql, databricks_host, warehouse_id, token) {
  
  # Submit statement
  res <- POST(
    paste0("https://", databricks_host, "/api/2.0/sql/statements"),
    add_headers(
      Authorization = paste("Bearer", token),
      `Content-Type` = "application/json"
    ),
    body = toJSON(
      list(
        warehouse_id = warehouse_id,
        statement = sql
      ),
      auto_unbox = TRUE
    )
  )
  
  if (status_code(res) != 200)
    stop("Failed to submit SQL query")
  
  statement_id <- content(res)$statement_id
  
  # Poll until complete
  repeat {
    Sys.sleep(2)
    status_res <- GET(
      paste0(
        "https://",
        databricks_host,
        "/api/2.0/sql/statements/",
        statement_id
      ),
      add_headers(Authorization = paste("Bearer", token))
    )
    
    state <- content(status_res)$status$state
    if (!state %in% c("PENDING", "QUEUED", "RUNNING")) break
  }
  
  if (state != "SUCCEEDED")
    stop("Query failed")
  
  response <- content(status_res)
  
  # Handle empty result set
  if (is.null(response$result$data_array))
    return(data.frame())
  
  # Extract column names (CORRECT LOCATION)
  col_names <- vapply(
    response$manifest$schema$columns,
    function(x) x$name,
    character(1)
  )
  
  # Build data frame
  df <- as.data.frame(
    do.call(rbind, response$result$data_array),
    stringsAsFactors = FALSE
  )
  
  colnames(df) <- col_names
  
  df
}

stop_warehouse <- function(databricks_host, warehouse_id, token) {
  POST(
    paste0("https://", databricks_host, "/api/2.0/sql/warehouses/", warehouse_id, "/stop"),
    add_headers(Authorization = paste("Bearer", token))
  )
}