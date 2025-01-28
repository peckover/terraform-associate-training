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

data "terraform_remote_state" "stage_0" {
  backend = "local"

  config = {
    path = "../stage0/state/terraform.tfstate"
  }
}

data "aws_ami" "amazon_linux_2_latest" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*-gp2"]
  }
  most_recent = true
  owners      = ["137112412989"] # Official AWS Account ID
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_2_latest.id
  instance_type = "t2.micro"
  availability_zone = "eu-west-2a"

  tags = data.terraform_remote_state.stage_0.outputs.standard_tags
  volume_tags = data.terraform_remote_state.stage_0.outputs.standard_tags
}

resource "aws_volume_attachment" "ebs_vol_attach" {
  device_name = "/dev/sdb"
  volume_id   = data.terraform_remote_state.stage_0.outputs.ebs_volume_id
  instance_id = aws_instance.example.id
}
