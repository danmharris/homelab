terraform {
  required_version = ">= 1.4.5"
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.4.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://tangor.dnhrrs.xyz:8006/api2/json"
  pm_tls_insecure = true
}
