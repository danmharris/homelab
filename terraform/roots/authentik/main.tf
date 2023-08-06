terraform {
  required_version = ">= 1.3.9"
  cloud {
    organization = "danmharris"

    workspaces {
      name = "authentik"
    }
  }

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2023.6.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "sops_file" "secrets" {
  source_file = "secrets.sops.yaml"
  input_type  = "yaml"
}
