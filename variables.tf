variable "aws_region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "aws_profile" {
  default     = "viniciustrainotti"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}

variable "environment" {
  type = string
  description = "Environment"
  default = "prod"
}
