variable "aws_region" {
  description = "Regione AWS in cui creare le risorse del laboratorio"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Nome del progetto usato nei naming delle risorse"
  type        = string
  default     = "gestionale"
}

variable "environment" {
  description = "Environment del laboratorio"
  type        = string
  default     = "lab"
}

variable "owner" {
  description = "Owner o team responsabile delle risorse"
  type        = string
  default     = "student"
}

variable "bucket_prefix" {
  description = "Prefisso del bucket S3; Terraform aggiunge un suffisso casuale per renderlo univoco"
  type        = string
  default     = "ial-terraform-core"
}

variable "log_retention_days" {
  description = "Retention dei log CloudWatch per il laboratorio"
  type        = number
  default     = 7

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30], var.log_retention_days)
    error_message = "log_retention_days deve essere uno tra: 1, 3, 5, 7, 14, 30."
  }
}
