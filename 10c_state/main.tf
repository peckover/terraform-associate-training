terraform {
  required_version = ">=1.4"
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "4.5.0"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = var.token
}

data "vault_generic_secret" "vault_secret" {
  path = "secret/example"
}


resource "local_file" "secret_file" {
  filename = "groceries.txt"
  content  = "I wish no one knew that ${data.vault_generic_secret.vault_secret.data["test_secret"]}"
}
