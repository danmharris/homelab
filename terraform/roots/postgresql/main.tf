terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.18.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}

data "sops_file" "credentials" {
  source_file = "credentials.enc.yml"
  input_type  = "yaml"
}
