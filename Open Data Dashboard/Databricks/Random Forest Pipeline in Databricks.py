##### Note this is just for eductional purposes, this will only work on my databricks platform

import dlt
from pyspark.sql.functions import col

@dlt.table(
  name="presdisp_clean",
  comment="Cleaned version of the presdisp parquet dataset"
)
def presdisp_clean():
    df = spark.read.table("workspace.nhs_application_machine_learning.presdisp")
    return df
