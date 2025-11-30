provider "aws" {
  region = "us-east-1"
}

############################
# VPC
############################
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "tf-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "tf-public-subnet" }
  availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "tf-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "tf-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

############################
# Security Group (SSH)
############################
resource "aws_security_group" "ec2_sg" {
  name        = "tf-ec2-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "tf-ec2-sg" }
}

############################
# IAM Role for EC2
############################
resource "aws_iam_role" "ec2_role" {
  name = "tf-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "tf-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

############################
# Linux EC2 with password auth
############################

resource "aws_key_pair" "deployer_key_pair" {
  key_name   = "my-terraform-key" # Name for the key pair in AWS
  # Path to your local public key file (~/.ssh/mykeypair_rsa.pub)
  public_key = file("mykeypair_rsa.pub")
}

resource "aws_instance" "ec2" {
  ami                         = "ami-0fa3fe0fa7920f68e" # Amazon Linux 2
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true
  key_name = aws_key_pair.deployer_key_pair.key_name

  tags = { Name = "tf-ec2" }
}


