terraform {
  required_version = ">= 1.3.9"
  cloud {
    organization = "danmharris"

    workspaces {
      name = "postgresql"
    }
  }

  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.21.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}

data "sops_file" "credentials" {
  source_file = "credentials.sops.yaml"
  input_type  = "yaml"
}
