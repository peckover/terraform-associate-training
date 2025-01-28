terraform {
  required_providers {
    gitpango = {
      source = "Pango-Inc/git"
      version = "0.1.4-pango.3"
    }
    gitnbarnum = {
      source = "nbarnum/git"
      version = "0.1.9"
    }
  }
}

data "git_repository" "this" {
  provider = gitpango
  path     = "../.."
}

data "git_repository" "that" {
  provider = gitnbarnum
  path     = "../.."
}
