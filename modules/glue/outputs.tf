output "glue_crawler_arn" {
  value = aws_glue_crawler.financial_crawler.arn
}

output "glue_etl_job_arn" {
  value = aws_glue_job.financial_etl.arn
}