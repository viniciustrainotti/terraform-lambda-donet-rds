data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-lambda-vpc"
    }
  )
}

resource "aws_subnet" "subnet_private" {
  count = length(local.cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = local.cidr_blocks[count.index]

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-lambda-subnet-private-${count.index}"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-lambda-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  count          = length(local.cidr_blocks)
  subnet_id      = element(aws_subnet.subnet_private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
