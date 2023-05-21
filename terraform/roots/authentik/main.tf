terraform {
  required_version = ">= 1.4.5"
  cloud {
    organization = "danmharris"

    workspaces {
      name = "authentik"
    }
  }

  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2023.5.0"
    }
  }
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}
