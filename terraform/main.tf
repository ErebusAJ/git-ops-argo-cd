terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


# Specifing local key-pair
resource "aws_key_pair" "terra-key" {
  key_name   = "terra-key"
  public_key = file("./ssh-keys/jenkins_ec2.pub") # takes local key and ingest to aws ec2
}

# Security Group
resource "aws_security_group" "my-ec2-sg" {
  name        = "jenkins-ec2-sg"
  description = "allow ssh from my ip"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "example" {
  ami                    = "ami-019715e0d74f695be"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.my-ec2-sg.id]
  user_data              = file("./scripts/bootstrap.sh") # install's jenkins

  tags = {
    Name = "terraform-test1"
  }

}
