import pandas as pd
import urllib
import requests


HB_Lookup = HB_Lookup.drop(columns=['Country', 'HBDateEnacted']).loc[HB_Lookup['HBDateArchived'].isna()]
HB_Lookup['GeoType'] = "Health Board"

Council_Lookup = Council_Lookup[['CA', 'CAName', 'CADateArchived']].loc[Council_Lookup['CADateArchived'].isna()]
Council_Lookup = Council_Lookup.drop(columns=['CADateArchived'])
Council_Lookup['GeoType'] = "Council Area"
Council_Lookup = Council_Lookup.rename(columns={'CA': 'GeoCode', 'CAName': 'GeoName'}).drop_duplicates()

Interminate_Zone_Lookup = Interminate_Zone_Lookup[['IntZone', 'IntZoneName', 'HB']]
Interminate_Zone_Lookup['GeoType'] = "Interminate Zone"
Interminate_Zone_Lookup = Interminate_Zone_Lookup.rename(columns={'IntZone': 'GeoCode', 'IntZoneName': 'GeoName'})

Hospital_Lookup = Hospital_Lookup[['HospitalCode', 'HospitalName', 'HealthBoard']]
Hospital_Lookup['GeoType'] = "Hospital"
Hospital_Lookup = Hospital_Lookup.rename(columns={'HospitalCode': 'GeoCode', 'HospitalName': 'GeoName', 'HealthBoard': 'HB'})

Data_Zone_Lookup = Data_Zone_Lookup[['DataZone', 'DataZoneName', 'HB']]
Data_Zone_Lookup['GeoType'] = "Data Zone"
Data_Zone_Lookup = Data_Zone_Lookup.rename(columns={'DataZone': 'GeoCode', 'DataZoneName': 'GeoName'})

Lookup_List = pd.concat([Council_Lookup, Interminate_Zone_Lookup, Hospital_Lookup, Data_Zone_Lookup], ignore_index=True)
