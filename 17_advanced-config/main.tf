terraform {
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
    # `regex` finds & outputs a pattern match within a string
    Name             = regex("[[:word:]]*.[[:word:]]*", var.capgemini_email)
    OwnerEmail       = var.capgemini_email
    ProjectOrPurpose = "Training"
    ServiceHours     = "Mon-Fri_8am-6pm"
    ExpirationDate   = var.expiration_date
  }
}

resource "aws_security_group" "allow_ing_eg" {
  name        = "allow_ing_eg"
  description = "Allow ingress/egress"

  # Here we are using a dynamic block to specify multiple `ingress` rules on the security group using a single piece of code. 
  # We are specifying the `sg_ingress_rules` var which is a list of map objects within `terraform.tfvars`
  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content {
      from_port = ingress.value["from_port"]
      to_port = ingress.value["to_port"]
      protocol = ingress.value["protocol"]
      cidr_blocks = [element(var.local_network_cidr, 0)] //retrieves a single element from a list at the specified index
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "local_file" "shopping_list" {
  filename = "shopping_list.txt"
  # Here we are using the `templatefile` function to provide a string, resultant from a .tpl file + inputs
  # Within the `templatefile` inputs, we are making another call out to the `formatdate` & `timestamp` functions
  content  = templatefile("templates/shopping_list.tpl", {
    date = formatdate("DD MMM YYYY", timestamp()), 
    list = var.shopping_list
  })
}
