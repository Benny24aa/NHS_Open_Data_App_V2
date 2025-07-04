WeeklyAE <- get_resource(res_id = "a5f7ca94-c810-41b5-a7c9-25c18d43e5a4")

WeeklyAE$WeekEndingDate <- as.Date(
  as.character(WeeklyAE$WeekEndingDate),
  format = "%Y%m%d"
)