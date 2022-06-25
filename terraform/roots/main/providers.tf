terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://tangor.dnhrrs.xyz:8006/api2/json"
  pm_tls_insecure = true
}
