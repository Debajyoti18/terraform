variable "region" {
  default = "eu-north-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}
provider "aws" {
  region = var.region
}

# Create key pair
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.key.private_key_pem
  filename = "${path.module}/my-key.pem"
  file_permission = "0400"
}

# VPC
resource "aws_vpc" "dj" {
  cidr_block = var.cidr
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.dj.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.dj.id
  cidr_block = "10.0.2.0/24"
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dj.id
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dj.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table (no IG/NAT for now)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dj.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

# Security Group for public instance
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.dj.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # From anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for private instance
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.dj.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]  # Only from public instance
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Public EC2 Instance
resource "aws_instance" "public_ec2" {
  ami           = "ami-01637463b2cbe7cb6" # Amazon Linux 2 for eu-north-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "Public-EC2"
  }
}

# Private EC2 Instance
resource "aws_instance" "private_ec2" {
  ami           = "ami-01637463b2cbe7cb6"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "Private-EC2"
  }
}
output "public_instance_ip" {
  value = aws_instance.public_ec2.public_ip
}

output "private_instance_ip" {
  value = aws_instance.private_ec2.private_ip
}

output "pem_file_location" {
  value = local_file.private_key_pem.filename
}
