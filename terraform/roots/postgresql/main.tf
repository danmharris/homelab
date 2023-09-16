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
      version = "1.20.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
}

data "sops_file" "credentials" {
  source_file = "credentials.sops.yaml"
  input_type  = "yaml"
}
