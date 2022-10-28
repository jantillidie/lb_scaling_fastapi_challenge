resource "aws_vpc" "fastapivpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "fastapivpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.fastapivpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    "Name" = "Public Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.fastapivpc.id
  tags = {
    "Name" = "IGW"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.fastapivpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
