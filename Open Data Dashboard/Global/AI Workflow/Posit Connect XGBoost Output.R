library(readxl)

url <- "https://019eebb6-d90d-fc95-6b0c-042e539250c5.share.connect.posit.cloud/Databricks/ae%20outputs/combined_future_forecasts.xlsx"

tmp <- tempfile(fileext = ".xlsx")

download.file(
  url = url,
  destfile = tmp,
  mode = "wb"
)

print(file.exists(tmp))
print(file.info(tmp)$size)

accident_emergency_xgboost_model <- read_excel(tmp)
