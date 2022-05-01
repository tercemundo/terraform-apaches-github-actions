terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
  }

  backend "s3" {
    bucket = "terraform-env-bucket"
    key    = "tf/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1" # Define your AWS region you want to use for the resources to be created in
}
