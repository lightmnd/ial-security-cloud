locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_s3_bucket" "lab_data" {
  bucket_prefix = "${var.bucket_prefix}-${var.environment}-"
  force_destroy = true

  tags = {
    Name = "${local.name_prefix}-data"
  }
}

resource "aws_s3_bucket_versioning" "lab_data" {
  bucket = aws_s3_bucket.lab_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab_data" {
  bucket = aws_s3_bucket.lab_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lab_data" {
  bucket = aws_s3_bucket.lab_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/gestionale/${local.name_prefix}"
  retention_in_days = var.log_retention_days
}

output "aws_account_id" {
  description = "AWS Account corrente"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "Regione AWS usata nel laboratorio"
  value       = data.aws_region.current.name
}

output "s3_bucket_name" {
  description = "Nome del bucket S3 creato"
  value       = aws_s3_bucket.lab_data.bucket
}

output "cloudwatch_log_group_name" {
  description = "Nome del log group CloudWatch"
  value       = aws_cloudwatch_log_group.app.name
}
