resource "aws_security_group" "sg_rds" {
  name        = "${var.environment} sg_rds"
  description = "${var.environment} security group for private db"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "PostgreSQL access from within VPC"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  depends_on = [
    aws_vpc.main
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "lambda_sg"
    }
  )
}
