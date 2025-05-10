Cancer_Waiting_Times <- get_resource(res_id = "58527343-a930-4058-bf9e-3c6e5cb04010")

Cancer_Waiting_Times_T <- Cancer_Waiting_Times %>% 
  select(Quarter,HB,HBT, CancerType ,NumberOfEligibleReferrals31DayStandard, NumberOfEligibleReferralsTreatedWithin31Days) %>% 
  mutate(Percent_31_Days = NumberOfEligibleReferralsTreatedWithin31Days/NumberOfEligibleReferrals31DayStandard * 100)

Cancer_Waiting_Times_T <- full_join(Cancer_Waiting_Times_T, HB_Lookup, by = "HB") %>% 
  select(-HB, -GeoType) %>% 
  rename(Health_Board_Patient = HBName)

HB_Lookup_Treatment <- HB_Lookup %>% 
  rename(HBT = HB)

Cancer_Waiting_Times_T <- full_join(Cancer_Waiting_Times_T, HB_Lookup_Treatment, by = "HBT") %>% 
  select(-GeoType, -HBT)