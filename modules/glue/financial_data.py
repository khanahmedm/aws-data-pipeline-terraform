import sys
import boto3
from datetime import datetime
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.transforms import *
from awsglue.job import Job

from pyspark.sql.functions import col

# Initialize Glue context
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

# Define AWS Glue database and table
glue_database = "financial-data-raw-demo"
glue_table = "transactionsfinancial_data_raw_amk"

current_timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
s3_bucket = "financial-data-curated-demo-amk"
s3_prefix = "transactions_curated_"  # Prefix for new output
s3_output_path = f"s3://{s3_bucket}/{s3_prefix}{current_timestamp}.csv"

# Initialize Boto3 client for S3
s3_client = boto3.client("s3")

# Function to delete existing files in the S3 bucket
def delete_existing_files(bucket_name, prefix):
    response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
    
    if "Contents" in response:
        print(f"Deleting existing files in s3://{bucket_name}/{prefix} ...")
        objects_to_delete = [{"Key": obj["Key"]} for obj in response["Contents"]]
        s3_client.delete_objects(Bucket=bucket_name, Delete={"Objects": objects_to_delete})
        print("Old files deleted successfully.")

# Call the function to delete existing files
delete_existing_files(s3_bucket, s3_prefix)


# Read data from AWS Glue Catalog table
datasource0 = glueContext.create_dynamic_frame.from_catalog(
    database=glue_database,
    table_name=glue_table
)

# Convert Glue DynamicFrame to Spark DataFrame
df = datasource0.toDF()

# Filter rows where status = 'Completed'
filtered_df = df.filter(col("status") == "Completed")

# Convert back to Glue DynamicFrame
filtered_dynamic_frame = DynamicFrame.fromDF(filtered_df, glueContext, "filtered_dynamic_frame")

# Write the filtered data back to S3 in CSV format
glueContext.write_dynamic_frame.from_options(
    frame=filtered_dynamic_frame,
    connection_type="s3",
    format="csv",
    connection_options={"path": s3_output_path, "partitionKeys": []},
    transformation_ctx="datasink2",
)

print("Filtered data successfully written to S3.")

job.commit()
