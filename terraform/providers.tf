terraform {
  required_providers {
    powerdns = {
      source = "pan-net/powerdns"
      version = "1.4.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.1"
    }
  }
}

provider "powerdns" {
  api_key    = var.pdns_api_key
  server_url = var.pdns_server_url
}

provider "proxmox" {
  pm_api_url      = var.proxmox_url
  pm_tls_insecure = true
  pm_user         = var.proxmox_username
  pm_password     = var.proxmox_password
}
