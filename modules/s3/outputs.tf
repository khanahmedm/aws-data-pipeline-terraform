output "glue_script_bucket_name" {
  value = aws_s3_bucket.glue_script_bucket.bucket
}

output "financial_raw_data_bucket_name" {
  value = aws_s3_bucket.raw_data.bucket
}

output "raw_data_bucket_arn" {
  value = aws_s3_bucket.raw_data.arn
}

output "raw_data_bucket_id" {
  value = aws_s3_bucket.raw_data.id
}

output "curated_data_bucket_arn" {
  value = aws_s3_bucket.curated_data.arn
}

output "glue_script_bucket_arn" {
  value = aws_s3_bucket.glue_script_bucket.arn
}
