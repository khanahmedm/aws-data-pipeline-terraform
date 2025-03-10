resource "aws_iam_role" "step_functions_role" {
  name = "step_functions_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "step_functions_policy" {
  name = "step_functions_execution_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          var.extract_data_lambda_arn,
          var.trigger_glue_crawler_lambda_arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:StartJobRun"
        ]
        Resource = [
          var.glue_etl_job_arn
        ]
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "step_functions_policy_attach" {
  role       = aws_iam_role.step_functions_role.name
  policy_arn = aws_iam_policy.step_functions_policy.arn
}

/*
data "template_file" "sfn_definition" {
  template = file("${path.module}/step_functions_definition.json")

  vars = {
    extract_data_lambda_arn  = var.extract_data_lambda_arn
    trigger_glue_crawler_lambda_arn = var.trigger_glue_crawler_lambda_arn
    glue_etl_job_arn         = var.glue_etl_job_arn
  }
}
*/

resource "aws_sfn_state_machine" "etl_pipeline" {
  name     = "FinancialDataPipeline"
  #role_arn = var.step_functions_role_arn
  role_arn = aws_iam_role.step_functions_role.arn
  #definition = data.template_file.sfn_definition.rendered

  definition = jsonencode({
    Comment = "Invoke Lambda to write Hello World to S3",
    StartAt = "InvokeLambda",
    States = {
      InvokeLambda = {
        Type     = "Task",
        Resource = var.extract_data_lambda_arn,
        End      = true
      }
    }
  })
}
