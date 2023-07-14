resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "subnet-public" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnets_cidr
  map_public_ip_on_launch = true # This is what makes it a public subnet
  availability_zone       = var.availability_zones[0]
  tags = {
    Name = "subnet-public"
  }
}

resource "aws_subnet" "subnet-private" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.private_subnets_cidr
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "subnet-private"
  }
}

# Add internet gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "igw"
  }
}

# Public routes
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "public-routetable"
  }
}
resource "aws_route_table_association" "public-subnetassociate" {
  subnet_id      = aws_subnet.subnet-public.id
  route_table_id = aws_route_table.public-route.id
}

# NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "nat_eip" {
  vpc = true
}
resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet-public.id

  tags = {
    Name = "NAT Gateway"
  }
}

# Private routes
resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = "private-routetable"
  }
}
resource "aws_route_table_association" "private-subnetassociation" {
  subnet_id      = aws_subnet.subnet-private.id
  route_table_id = aws_route_table.private-route.id
}