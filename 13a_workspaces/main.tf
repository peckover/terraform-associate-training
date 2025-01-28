terraform {
  required_version = ">=1.4"

  backend "s3" {
    # Replace this with your S3 bucket name
    bucket         = "jp-state-bucket-28-01"
    key            = "lab13-01-workspaces/terraform.tfstate"
    region         = "eu-west-2"
    # Replace this with your DynamoDB table name
    dynamodb_table = "jp-locks-28-01"
    encrypt        = true
    profile        = "lease"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "eu-west-2"
  shared_credentials_files = ["/Users/peckover/.aws/credentials"]
  profile                 = "lease"
}


locals {
  tags = {
    Name             = "${var.capgemini_email}-${terraform.workspace}-ec2"
    OwnerEmail       = var.capgemini_email
    ProjectOrPurpose = "Training"
    ServiceHours     = "Mon-Fri_8am-6pm"
    ExpirationDate   = var.expiration_date
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = local.tags
}

resource "aws_s3_bucket" "this" {

  bucket = "${var.bucket_name}-${terraform.workspace}"

  tags = local.tags

}
