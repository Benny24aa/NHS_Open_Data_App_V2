

library(httr)
library(jsonlite)

source("Global/AI Workflow/Databricks Variables.R") ### This won't appear on the github repo

# ---------------------------
# Get warehouse status
# ---------------------------
get_warehouse_status <- function() {
  res <- GET(
    paste0("https://", databricks_host, "/api/2.0/sql/warehouses/", warehouse_id),
    add_headers(Authorization = paste("Bearer", token))
  )
  
  if (status_code(res) != 200) stop("Failed to get warehouse status")
  content(res)$state
}

# ---------------------------
# 2. Start warehouse if not running
# ---------------------------
status <- get_warehouse_status()
if (status != "RUNNING") {
  cat("Starting warehouse...\n")
  
  res_start <- POST(
    paste0("https://", databricks_host, "/api/2.0/sql/warehouses/", warehouse_id, "/start"),
    add_headers(Authorization = paste("Bearer", token))
  )
  
  if (status_code(res_start) != 200) stop("Failed to start warehouse")
  
  repeat {
    Sys.sleep(10)
    status <- get_warehouse_status()
    cat(".")
    if (status == "RUNNING") break
  }
  cat("\nWarehouse is now running!\n")
} else {
  cat("Warehouse is already running.\n")
}

# ---------------------------
# 3. Function to execute SQL query
# ---------------------------
execute_query <- function(sql) {
  res <- POST(
    paste0("https://", databricks_host, "/api/2.0/sql/statements"),
    add_headers(
      Authorization = paste("Bearer", token),
      `Content-Type` = "application/json"
    ),
    body = toJSON(list(warehouse_id = warehouse_id, statement = sql), auto_unbox = TRUE)
  )
  
  if (status_code(res) != 200) {
    cat("Failed to submit SQL query. Response:\n")
    print(content(res, "text"))
    stop("Stopping execution due to submission failure.")
  }
  
  res_content <- content(res)
  statement_id <- res_content$statement_id
  cat("Query submitted, statement ID:", statement_id, "\n")
  
  repeat {
    Sys.sleep(2)
    status_res <- GET(
      paste0("https://", databricks_host, "/api/2.0/sql/statements/", statement_id),
      add_headers(Authorization = paste("Bearer", token))
    )
    
    status_content <- content(status_res)
    stmt_status <- status_content$status$state
    cat("Status:", stmt_status, "\n")
    
    if (!(stmt_status %in% c("PENDING", "QUEUED", "RUNNING"))) break
  }
  
  if (stmt_status != "SUCCEEDED") stop("Query failed or canceled. Status: ", stmt_status)
  
  # Extract results into data.frame
  result <- status_content$result
  if (!is.null(result$data)) {
    cols <- sapply(result$metadata, `[[`, "name")
    data <- as.data.frame(do.call(rbind, result$data))
    names(data) <- cols
    return(data)
  } else {
    return(data.frame())
  }
}

# ---------------------------
# Queries
# ---------------------------
# hospital_list_df <- execute_query("SELECT * FROM nhs_waiting_times_dashboard.default.hospital_list")



# ---------------------------
# Stop warehouse
# ---------------------------
cat("Stopping warehouse.\n")
res_stop <- POST(
  paste0("https://", databricks_host, "/api/2.0/sql/warehouses/", warehouse_id, "/stop"),
  add_headers(Authorization = paste("Bearer", token))
)
if (status_code(res_stop) != 200) {
  cat("Failed to stop warehouse. Response:\n")
  print(content(res_stop, "text"))
} else {
  cat("Warehouse stopped successfully.\n")
}


