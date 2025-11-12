import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
import seaborn as sns
import matplotlib.pyplot as plt


# Read your Lakeflow Declarative Pipelines output table
df_spark = spark.read.table("workspace.default.presdisp_clean")

# Convert to Pandas for sklearn
df = df_spark.toPandas()

df["PrescriberLocation"] = pd.to_numeric(df["PrescriberLocation"], errors="coerce")

df["PaidDateMonth"] = pd.to_datetime(
    df["PaidDateMonth"],
    format="%Y%m",
    errors="coerce"
)
df["MonthNum"] = df["PaidDateMonth"].dt.month
df["Year"] = df["PaidDateMonth"].dt.year
