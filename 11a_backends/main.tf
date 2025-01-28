terraform {
  required_version = ">=1.4"
  backend "s3" {
    bucket  = "jp-state-bucket-28-01"
    key     = "global/s3/terraform.tfstate"
    region  = "eu-west-2"
    profile = "lease"

    dynamodb_table = "jp-locks-28-01"

    # Setting this to true ensures that the Terrafrom state will be encrypted on disk when stored in S3, even if the bucket itself does not have default encryption enabled.
    # In our case, the S3 bucket itself has already been configured with default encryption enabled, so setting this here is redundant.
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

locals {
  tags = {
    OwnerEmail       = var.capgemini_email
    ProjectOrPurpose = "Training"
    ServiceHours     = "Mon-Fri_8am-6pm"
    ExpirationDate   = "2025-01-29"
  }
}

provider "aws" {
  region                   = "eu-west-2"
  shared_credentials_files = ["/Users/peckover/.aws/credentials"]
  profile                  = "lease"
}

resource "aws_s3_bucket" "terraform_state" {

  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags

}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"


  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags

}

