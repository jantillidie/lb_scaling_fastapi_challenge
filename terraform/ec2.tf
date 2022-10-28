resource "aws_security_group" "ssh_http_security" {
  name        = "allow_http_port_ssh"
  description = "Allow HTTP Port 8000 and SSH"
  vpc_id      = aws_vpc.fastapivpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Port 8000"
    from_port   = 8000
    protocol    = "tcp"
    to_port     = 8000
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    to_port          = 0
  }
  tags = {
    "Name" = "allow_http_port_ssh"
  }
}

resource "aws_instance" "fastapiec2" {
  ami                         = "ami-08e2d37b6a0129927"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ssh_http_security.id]
  key_name                    = "vockey"
  user_data                   = file("userdata.sh")
  depends_on = [aws_s3_bucket.fastapibucket]
  tags = {
    "Name" = "fastapiec2"
  }
}
