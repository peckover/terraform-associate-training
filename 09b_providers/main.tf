terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" //highest 5.x version
    }
  }
}

provider "aws" {
  region     = "eu-west-2"
  shared_credentials_files = ["/Users/peckover/.aws/credentials"]
  profile                 = "lease"
}


data "aws_s3_bucket" "my_bucket" {
  bucket = "jp-terraform-bucket-01-25"
}
