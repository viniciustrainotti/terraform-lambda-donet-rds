resource "aws_db_parameter_group" "this" {
  name   = "lambda"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_subnet_group" "subg" {
  name       = "subnet group db instance"
  subnet_ids = [aws_subnet.subnet_private[0].id, aws_subnet.subnet_private[1].id]

  depends_on = [
    aws_subnet.subnet_private
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "subnet group db instance"
    }
  )
}


resource "aws_db_instance" "this" {
  identifier             = "dblambda"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = "lambda"
  db_name                = "lambdadotnet"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.subg.name
  vpc_security_group_ids = [aws_security_group.sg_rds.id]
  parameter_group_name   = aws_db_parameter_group.this.name
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = merge(
    local.common_tags,
    {
      Name = "dblambda"
    }
  )
}
