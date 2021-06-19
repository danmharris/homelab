variable "pdns_api_key" {
  type = string
  sensitive = true
}

variable "pdns_server_url" {
  type = string
}

variable "proxmox_url" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "proxmox_boot_order" {
  type    = string
  default = "order=scsi0;ide2;net0"
}

variable "ssh_public_key" {
  type = string
}
