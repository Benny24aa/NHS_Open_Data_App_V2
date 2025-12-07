# --- Load libraries ---
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.functions import col, month, year, abs as spark_abs, expr
from pyspark.ml.feature import StringIndexer, VectorAssembler
from pyspark.ml.regression import RandomForestRegressor
from pyspark.ml import Pipeline

# --- Initialize Spark session ---
spark = SparkSession.builder.getOrCreate()

# --- Load main prescribing dataset from Databricks table ---
df = spark.read.table("workspace.default.presdisp_clean_full")

# --- Keep PrescriberLocation as string ---
# df['PrescriberLocation'] is already string, no cast needed

# --- Safely convert numeric columns ---
df = df.withColumn("NumberOfPaidItems", expr("try_cast(NumberOfPaidItems as double)")) \
       .withColumn("PracticeListSize", expr("try_cast(PracticeListSize as double)"))

# Filter out rows with invalid numeric values
df = df.filter(col("NumberOfPaidItems").isNotNull() & col("PracticeListSize").isNotNull())

# --- Load GP practice list ---
df_gp = spark.read.table("nhs_waiting_times_dashboard.default.gplist") \
    .select("PrescriberLocation", "HB", "HSCP", "DataZone", "GPCluster", "PracticeListSize") \
    .dropDuplicates()

# --- Filter for GP practices and community pharmacies ---
df = df.filter((col("PrescriberLocationType") == "GP PRACTICE") &
               (col("DispenserLocationType") == "COMMUNITY PHARMACY"))

# --- Join GP metadata ---
df = df.join(df_gp, on="PrescriberLocation", how="left")

# Filter for specific Health Board
df = df.filter(col("HB") == "S08000031")

# --- Convert dates and extract time features ---
df = df.withColumn("PaidDateMonth", F.to_date(col("PaidDateMonth"), "yyyy-MM")) \
       .withColumn("MonthNum", month(col("PaidDateMonth"))) \
       .withColumn("Year", year(col("PaidDateMonth")))

# --- Prepare features for ML ---
hs_indexer = StringIndexer(inputCol="HSCP", outputCol="HSCP_idx", handleInvalid="keep")
dz_indexer = StringIndexer(inputCol="DataZone", outputCol="DataZone_idx", handleInvalid="keep")
cluster_indexer = StringIndexer(inputCol="GPCluster", outputCol="GPCluster_idx", handleInvalid="keep")

assembler = VectorAssembler(
    inputCols=["MonthNum", "HSCP_idx", "DataZone_idx", "GPCluster_idx"],
    outputCol="features"
)

rf = RandomForestRegressor(labelCol="NumberOfPaidItems", featuresCol="features", numTrees=200, seed=123)

pipeline = Pipeline(stages=[hs_indexer, dz_indexer, cluster_indexer, assembler, rf])

# --- Train model ---
model = pipeline.fit(df)

# --- Generate predictions ---
predictions = model.transform(df)  # using same table for demonstration

# --- Calculate residuals ---
predictions = predictions.withColumn("Residual", col("NumberOfPaidItems") - col("prediction")) \
                         .withColumn("AbsResidual", spark_abs(col("Residual")))

# --- Identify top 5% outliers ---
threshold = predictions.approxQuantile("AbsResidual", [0.95], 0.0)[0]
predictions = predictions.withColumn("Outlier", col("AbsResidual") > threshold)

# --- Summary ---
outlier_count = predictions.filter(col("Outlier") == True).count()
total_count = predictions.count()

print(f"Outlier threshold: {threshold:.2f}")
print(f"Number of outliers: {outlier_count} of {total_count}")

# View top 10 most extreme outliers
predictions.orderBy(col("AbsResidual").desc()).show(10)
