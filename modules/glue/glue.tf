# Step 1: Create a Glue Crawler
resource "aws_glue_crawler" "financial_crawler" {
  name          = "financial-data-raw-crawler"
  database_name = "financial-data-raw"
  role          = "arn:aws:iam::585768163077:role/service-role/AWSGlueServiceRole-financial-data"

  s3_target {
    path = "s3://${var.financial_raw_data_bucket_name}/"
  }
}

# Step 2: Upload Glue Script to S3
resource "aws_s3_object" "glue_script" {
  bucket = var.glue_script_bucket_name  # Use the passed variable instead of a direct reference
  key    = "financial_data.py"  # The file name in S3
  source = "./modules/glue/financial_data.py"  # The local file to upload
  acl    = "private"
}

# Step 3: Create a Glue ETL job
resource "aws_glue_job" "financial_etl" {
  name     = "financial-data-etl"
  role_arn = "arn:aws:iam::585768163077:role/service-role/AWSGlueServiceRole-financial-data"
  command {
    script_location = "s3://glue-script-bucket-demo-amk/financial_data.py"
  }
}


