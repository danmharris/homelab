terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.1"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_url
  pm_tls_insecure = true
  pm_user         = var.proxmox_username
  pm_password     = var.proxmox_password
}
