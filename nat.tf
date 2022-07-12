# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.subnet_private.*.id, 0)

  tags =  merge(
    local.common_tags,
    {
      Name        = "${var.environment} nat"
      Environment = "${var.environment}"
  })
}
