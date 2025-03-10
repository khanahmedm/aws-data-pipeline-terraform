variable "lambda_role_arn" {
  type        = string
  description = "IAM Role ARN for Step Functions execution"
}

variable "extract_data_lambda_arn" {
  type        = string
  description = "ARN of the Lambda function that extracts data from PostgreSQL"
}

variable "trigger_glue_crawler_lambda_arn" {
  type        = string
  description = "ARN of the Lambda function that triggers the Glue Crawler"
}

variable "glue_etl_job_arn" {
  type        = string
  description = "ARN of the AWS Glue ETL job"
}

variable "glue_crawler_arn" {
  type        = string
  description = "ARN of the AWS Glue Crawler"
}

/*
variable "step_functions_role_arn" {
  type        = string
  description = "IAM Role ARN for Step Functions execution"
}
*/