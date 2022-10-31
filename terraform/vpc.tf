resource "aws_vpc" "fastapivpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "fastapivpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.fastapivpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
  tags = {
    "Name" = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.fastapivpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2b"
  tags = {
    "Name" = "Public Subnet 2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.fastapivpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2a"
  tags = {
    "Name" = "Private Subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.fastapivpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  tags = {
    "Name" = "Private Subnet 2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.fastapivpc.id
  tags = {
    "Name" = "IGW"
  }
}

resource "aws_eip" "nat_ip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_default_route_table" "private_route_table" {
  default_route_table_id = aws_vpc.fastapivpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    "Name" = "Private Route Table"
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

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "http_ssh"
  description = "Allow HTTP on Port 8000 and SSH"
  vpc_id      = aws_vpc.fastapivpc.id

  ingress {
    description = "Http"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    security_groups = [ aws_security_group.allow_http_lb.id ]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
