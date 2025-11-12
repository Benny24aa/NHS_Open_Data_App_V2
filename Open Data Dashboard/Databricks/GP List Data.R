gp_list <- get_resource(res_id = "30b06220-17ad-44e8-b6c5-658d41ec1ea5") %>%
  select(PracticeCode, HB, HSCP, DataZone, GPCluster, PracticeListSize) %>%
  distinct() %>%
  rename(PrescriberLocation = PracticeCode) 