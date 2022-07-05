data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    local.common_tags,
    {
      Name = "lambda_vpc"
    }
  )
}

resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(
    local.common_tags,
    {
      Name = "lambda_subnet_private"
    }
  )
}

resource "aws_subnet" "subnet_private_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(
    local.common_tags,
    {
      Name = "lambda_subnet_private_1"
    }
  )
}

resource "aws_security_group" "sg_rds" {
  name        = "sg_rds"
  description = "security group for private db"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "PostgreSQL access from within VPC"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "lambda_sg"
    }
  )
}
