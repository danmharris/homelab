terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.4.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://tangor.dnhrrs.xyz:8006/api2/json"
  pm_tls_insecure = true
}

variable "ssh_public_key" {
  type = string
}

module "db_cluster" {
  source         = "../../modules/db"
  cores          = 1
  ram            = "1024"
  disk           = "20"
  replica_ips    = ["10.23.20.105"]
  primary_ip     = "10.23.20.105"
  ssh_public_key = var.ssh_public_key
  template       = "debian10"
}
