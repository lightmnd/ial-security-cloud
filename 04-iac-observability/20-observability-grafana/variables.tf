variable "aws_region" {
  description = "AWS region where the demo Lambda will be created"
  type        = string
  default     = "eu-west-1"
}

variable "lambda_function_name" {
  description = "Name of the demo Lambda used to generate CloudWatch metrics for Grafana"
  type        = string
  default     = "grafana-demo-metrics"
}
