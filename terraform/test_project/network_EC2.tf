
resource "aws_vpc" "ssm_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ssm-vpc"
  }
}

resource "aws_internet_gateway" "ssm-igw" {
  
  vpc_id = aws_vpc.ssm_vpc.id

  tags = {
    Name = "ssm-igw" 
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "ssm-nat-eip"
  }
}

resource "aws_nat_gateway" "ssm-nat-gw" {
 
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.nat-subnet.id

  tags = {
    Name = "ssm-nat-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ssm_vpc.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ssm-igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ssm_vpc.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route" "private_default_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ssm-nat-gw.id
}

resource "aws_subnet" "nat-subnet" {
  vpc_id     = aws_vpc.ssm_vpc.id
  cidr_block = "10.0.0.0/26"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "nat-subnet"
  }
}

resource "aws_subnet" "ssm-private-subnet" {
  vpc_id            = aws_vpc.ssm_vpc.id
  cidr_block        = "10.0.0.128/26"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "ssm-private-subnet"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.nat-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.ssm-private-subnet.id
  route_table_id = aws_route_table.private.id
}

