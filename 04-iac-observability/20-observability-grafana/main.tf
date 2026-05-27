terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda-demo.py"
  output_path = "${path.module}/lambda-demo.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "grafana-demo-metrics-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "grafana_demo_metrics" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec.arn
  runtime          = "python3.12"
  handler          = "lambda-demo.lambda_handler"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 10

  depends_on = [aws_iam_role_policy_attachment.lambda_basic_execution]

  tags = {
    Project = "ial-security-cloud"
    Module  = "20-observability-grafana"
    Demo    = "true"
  }
}

output "lambda_function_name" {
  description = "Name of the demo Lambda used by Grafana/CloudWatch"
  value       = aws_lambda_function.grafana_demo_metrics.function_name
}

output "lambda_function_arn" {
  description = "ARN of the demo Lambda used by Grafana/CloudWatch"
  value       = aws_lambda_function.grafana_demo_metrics.arn
}

output "aws_account_id" {
  description = "AWS account ID where the demo Lambda was created"
  value       = data.aws_caller_identity.current.account_id
}
