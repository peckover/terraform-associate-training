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

locals {
  tags = {
    Name             = "${var.capgemini_email}-volume"
    OwnerEmail       = var.capgemini_email
    ProjectOrPurpose = "Training"
    ServiceHours     = "Mon-Fri_8am-6pm"
    ExpirationDate   = var.expiration_date
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = "eu-west-2a"
  size              = 1

  tags = local.tags
}
