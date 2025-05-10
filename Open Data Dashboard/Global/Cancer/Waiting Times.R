Cancer_Waiting_Times_31_days <- get_resource(res_id = "58527343-a930-4058-bf9e-3c6e5cb04010") %>% 
  filter(HBT != "S92000003")

Cancer_Waiting_Times_31_days_T <- Cancer_Waiting_Times_31_days %>% 
  select(Quarter,HB,HBT, CancerType ,NumberOfEligibleReferrals31DayStandard, NumberOfEligibleReferralsTreatedWithin31Days) %>% 
  mutate(Percent_31_Days = NumberOfEligibleReferralsTreatedWithin31Days/NumberOfEligibleReferrals31DayStandard * 100)

Cancer_Waiting_Times_31_days_T <- full_join(Cancer_Waiting_Times_31_days_T, HB_Lookup, by = "HB") %>% 
  select(-HB, -GeoType) %>% 
  rename(Health_Board_Patient = HBName)

HB_Lookup_Treatment <- HB_Lookup %>% 
  rename(HBT = HB) 

HBT <- c('SB0801')
HBName <- c('Golden Jubilee Hospital')
GeoType <- c('Health Board')

HBTreatGold <- data.frame(HBT, HBName, GeoType)

HB_Lookup_Treatment <- bind_rows(HB_Lookup_Treatment, HBTreatGold)


Cancer_Waiting_Times_31_days_T <- full_join(Cancer_Waiting_Times_31_days_T, HB_Lookup_Treatment, by = "HBT") %>% 
  select(-GeoType, -HBT) %>% 
  rename(Health_Board_Patient_Treatment = HBName)

Cancer_Waiting_Times_62_days <- get_resource(res_id = "23b3bbf7-7a37-4f86-974b-6360d6748e08") %>% 
  filter(HBT != "S92000003")

Cancer_Waiting_Times_62_days_T <- Cancer_Waiting_Times_62_days %>% 
  select(Quarter,HB,HBT, CancerType ,NumberOfEligibleReferrals62DayStandard, NumberOfEligibleReferralsTreatedWithin62Days) %>% 
  mutate(Percent_62_Days = NumberOfEligibleReferralsTreatedWithin62Days/NumberOfEligibleReferrals62DayStandard * 100)

Cancer_Waiting_Times_62_days_T <- full_join(Cancer_Waiting_Times_62_days_T, HB_Lookup, by = "HB") %>% 
  select(-HB, -GeoType) %>% 
  rename(Health_Board_Patient = HBName)


Cancer_Waiting_Times_62_days_T <- full_join(Cancer_Waiting_Times_62_days_T, HB_Lookup_Treatment, by = "HBT") %>% 
  select(-GeoType, -HBT) %>% 
  rename(Health_Board_Patient_Treatment = HBName)