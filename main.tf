provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS region  created"
  type        = string
  default     = "us-east-1"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "my-ec2-instance"
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "Name of the key pair for the instance"
  type        = string
  default     = "my-key-pair"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "my-security-group"
}

resource "aws_security_group" "ec2_security_group" {
  name        = var.security_group_name
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = var.instance_name
  }

  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
}

data "aws_ami" "ubuntu" {
  most_recent = true
          owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
