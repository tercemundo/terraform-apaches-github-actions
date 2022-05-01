data "aws_vpc" "vpc" {
  filter {
    name   = "tag-value"
    values = ["${var.vpc_name}"]
  }
}

variable "vpc_name" {
  default = "Default-VPC"
}

###################################

variable "tag_name" {
  default = ["First", "Second"]
}

variable "key_name" {
  default = "east1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_count" {
  default     = 2
  type        = number
  description = "Number of instances to create"
}

#########################
######### Data ##########
#########################

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
