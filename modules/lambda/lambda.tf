resource "aws_lambda_function" "extract_data" {
  function_name = "extractFinancialTransactions"
  role          = "arn:aws:iam::585768163077:role/service-role/extractTransactions-role-90bx92j5"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  timeout = 15
}

resource "aws_lambda_function" "start_glue_crawler" {
  function_name = "startFinancialGlueCrawler"
  role          = "arn:aws:iam::585768163077:role/service-role/startGlueCrawler-role-j0q665ix"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"

  filename         = "lambda_function_crawler.zip"
  source_code_hash = filebase64sha256("lambda_function_crawler.zip")

  timeout = 15
}


resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_glue_crawler.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.raw_data_bucket_arn
}


resource "aws_s3_bucket_notification" "s3_event" {
  bucket = var.raw_data_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.start_glue_crawler.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

