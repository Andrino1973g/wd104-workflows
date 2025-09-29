##1. VPC
resource "aws_vpc" "test-action" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

#2. Internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test-action.id

  tags = {
    Name = "igw"
  }
}

#3. Nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}

#4. EIP
resource "aws_eip" "lb" {

  tags = {
    Name = "nat-eip"
  }
}
#5. Public subnets
resource "aws_subnet" "public" {
  count = length(var.public_cidr)
  vpc_id     = aws_vpc.test-action.id
  cidr_block = element(var.public_cidr, count.index)

  tags = {
    Name = "Public"
  }
}

#6. Private subnets
resource "aws_subnet" "private" {
  count = length(var.private_cidr)
  vpc_id     = aws_vpc.test-action.id
  cidr_block = element(var.private_cidr, count.index)

  tags = {
    Name = "Private"
  }
}

#7. Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test-action.id

  tags = {
    Name = "Public-rt"
  }
}

#8. Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.test-action.id

  tags = {
    Name = "Private-rt"
  }
}
#9. Public routes
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

#10. Private routes
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

#11. Public subnet association
resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}
#12. Private subnet association
resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

#13. Flow logging
resource "aws_flow_log" "vpc" {
  log_destination      = data.aws_s3_bucket.action_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.test-action.id
}



