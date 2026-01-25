# --- Load libraries ---
library(data.table)
library(phsopendata)   # For live PHS data
library(dplyr)
library(lubridate)
library(ranger)        # Much faster alternative to randomForest
library(arrow)
library(glue)

###### Define the type of model you wish to run, this could be Alpha, Beta, Charlie, or Delta.

model_type <- "Alpha"