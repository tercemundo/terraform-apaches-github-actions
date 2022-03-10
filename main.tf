terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
  }
}

provider "aws" {
  region = "us-east-2" # Define your AWS region you want to use for the resources to be created in
}

resource "aws_security_group" "terraform-sg" {
  name = "terraform-project-sg"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
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

variable "tag_name" {
  default = ["First", "Second"]

}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

}

resource "aws_instance" "apache-server" {
  ami             = data.aws_ami.amazon-linux-2.id # Define the AMI you want to use
  instance_type   = "t2.micro"                     # Default instance type
  key_name        = "ssh1"                         # Define your SSH key name here
  count           = 2                              # Define the number of instances you want to create
  security_groups = ["terraform-project-sg"]       # Define your security group here
  user_data       = file("create_apache.sh")       # Define the user data script to be executed on the instance

  tags = { # Define the name of the instances you want to tag with count
    "Name" = "Terraform ${element(var.tag_name, count.index)} Instance"
  }

  provisioner "local-exec" { # Write the public IP of the instances to a file
    command = "echo ${self.public_ip} >> public_ip.txt"
  }

  provisioner "local-exec" { # Write the private IP of the instances to a file
    command = "echo ${self.private_ip} >> private_ip.txt"
  }

}

output "mypublicips" { # Define the output variable to see the public IP of the instances
  value = aws_instance.apache-server[*].public_ip

}
