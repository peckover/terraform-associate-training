terraform {
  backend "local" {
    path = "./state/terraform.tfstate"
  }
  required_version = ">=1.4"
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

data "aws_ami" "centos_9_latest" {
  filter {
    name   = "name"
    values = ["CentOS Stream 9*"]
  }
  most_recent = true
  owners      = ["125523088429"] # Official Centos AMI Account ID - https://wiki.centos.org/Cloud/AWS
}

resource "local_file" "dummy_file" {
  filename = "hello.txt"
  content  = "This is a file"
}
