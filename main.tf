module "s3" {
  source = "./modules/s3"
}

module "lambda" {
  source = "./modules/lambda"
  financial_raw_data_bucket_name = module.s3.financial_raw_data_bucket_name
  raw_data_bucket_arn = module.s3.raw_data_bucket_arn
  raw_data_bucket_id = module.s3.raw_data_bucket_id
}

module "glue" {
  source = "./modules/glue"
  glue_script_bucket_name = module.s3.glue_script_bucket_name  # Pass the bucket name from S3 module
  financial_raw_data_bucket_name = module.s3.financial_raw_data_bucket_name 
}

module "iam_roles" {
  source = "./modules/iam_roles"
  glue_crawler_arn = module.glue.glue_crawler_arn
}