locals {

  cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]

  common_tags = {
    Description = "Terraform Lambda with RDS"
    ManagedBy   = "Terraform"
    Owner       = "Vinícius Trainotti"
    CreatedAt   = "2022-07-04"
  }
}
