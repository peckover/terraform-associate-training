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

locals {
  tags = {
    Name             = var.capgemini_email
    OwnerEmail       = var.capgemini_email
    ProjectOrPurpose = "Training"
    ServiceHours     = "Mon-Fri_8am-6pm"
    ExpirationDate   = var.expiration_date
  }
}

provider "aws" {
  region = "eu-west-2"
  shared_credentials_files = ["/Users/peckover/.aws/credentials"]
  profile                 = "lease"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
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

//outputs from data objects above are used as inputs to the module

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"
  ami = data.aws_ami.ubuntu.id
  name = "example-normal"
  instance_type = "t3.micro"
  # subnet_id is listed as an optional dependency, but doesn't appear to be correct. So we define it below
  subnet_id = tolist(data.aws_subnets.all.ids)[0]
  associate_public_ip_address = false
  # Tags are also not a hard requirement of the module, rather of our DPE AWS account.
  # So we define them below as usual
  tags = local.tags
  volume_tags = local.tags
  # The unrequired "required" inputs
  # private_ip = 
  # ipv6_address_count = 
  # ipv6_addresses = 
  # user_data = 
  # user_data_base64 = 
  # vpc_security_group_ids = 

}
