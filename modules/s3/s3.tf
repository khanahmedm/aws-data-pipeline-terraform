# Step 1: Create the S3 Bucket financial-data-raw-demo-amk
resource "aws_s3_bucket" "raw_data" {
  bucket = "financial-data-raw-demo-amk"
}

# Step 2: Create the S3 Bucket financial-data-curated-demo-amk
resource "aws_s3_bucket" "curated_data" {
  bucket = "financial-data-curated-demo-amk"
}

# Step 3: Create the S3 Bucket glue-script-bucket-demo-amk
resource "aws_s3_bucket" "glue_script_bucket" {
  bucket = "glue-script-bucket-demo-amk"
}