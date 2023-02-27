# Vpc
resource "aws_vpc" "primary" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true
  instance_tenancy   = "default"

  tags = {
    Name = "primary-vpc"
    Env  = "dev"
  }
}

# Subnet - Public
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.0.0/19"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"


  tags = {
    Name = "primary-public-subnet"
    Env  = "dev"
  }
}

# IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "primary-igw"
    Env  = "dev"
  }
}

# Rtb
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "primary-rtb"
    Env  = "dev"
  }
}

# Rtb assoc
resource "aws_route_table_association" "primary_rtb_assoc_1" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rtb.id
}