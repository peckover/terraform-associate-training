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

resource "aws_ebs_volume" "example_volume" {
  availability_zone = "eu-west-2a"
  size              = 1

  tags = local.tags
}

data "aws_ami" "amazon_linux_2_latest" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*-gp2"]
  }
  most_recent = true
  owners      = ["137112412989"] # Official AWS Account ID
}

resource "aws_instance" "example_instance" {
  ami               = data.aws_ami.amazon_linux_2_latest.id
  instance_type     = "t2.micro"
  availability_zone = "eu-west-2a"

  tags        = local.tags
  volume_tags = local.tags
}

resource "aws_volume_attachment" "ebs_vol_attach" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.example_volume.id
  instance_id = aws_instance.example_instance.id
}

