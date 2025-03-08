variable "financial_raw_data_bucket_name" {
  description = "The S3 bucket where the raw data will be stored"
  type        = string
}

variable "raw_data_bucket_arn" {
  description = "ARN of the raw data S3 bucket"
  type        = string
}

variable "raw_data_bucket_id" {
  description = "id of the raw data S3 bucket"
  type        = string
}