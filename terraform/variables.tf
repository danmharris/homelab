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
