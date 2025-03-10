module "s3" {
  source = "./modules/s3"
}

module "lambda" {
  source = "./modules/lambda"
  financial_raw_data_bucket_name = module.s3.financial_raw_data_bucket_name
  raw_data_bucket_arn = module.s3.raw_data_bucket_arn
  raw_data_bucket_id = module.s3.raw_data_bucket_id
  lambda_role_arn = module.iam_roles.lambda_role_arn
}

module "glue" {
  source = "./modules/glue"
  glue_script_bucket_name = module.s3.glue_script_bucket_name  # Pass the bucket name from S3 module
  financial_raw_data_bucket_name = module.s3.financial_raw_data_bucket_name 
}

module "iam_roles" {
  source = "./modules/iam_roles"
  glue_crawler_arn = module.glue.glue_crawler_arn
  extract_data_lambda_arn  = module.lambda.extract_data_lambda_arn
  trigger_glue_crawler_lambda_arn = module.lambda.trigger_glue_crawler_lambda_arn
  glue_etl_job_arn         = module.glue.glue_etl_job_arn
}


module "rds" {
  source = "./modules/rds"
}


/*
output "lambda_role_arn" {
  value = module.iam_roles.lambda_role_arn
}

output "extract_data_lambda_arn" {
  value = module.lambda.extract_data_lambda_arn
}

output "trigger_glue_crawler_lambda_arn" {
  value = module.lambda.trigger_glue_crawler_lambda_arn
}

output "glue_etl_job_arn" {
  value = module.glue.glue_etl_job_arn
}

output "glue_crawler_arn" {
  value = module.glue.glue_crawler_arn
}
*/

module "step_functions" {
  source = "./modules/step_functions"

  extract_data_lambda_arn     = module.lambda.extract_data_lambda_arn
  trigger_glue_crawler_lambda_arn    = module.lambda.trigger_glue_crawler_lambda_arn
  glue_etl_job_arn            = module.glue.glue_etl_job_arn
  glue_crawler_arn            = module.glue.glue_crawler_arn
  lambda_role_arn             = module.iam_roles.lambda_role_arn
}
