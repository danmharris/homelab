variable "mysql_endpoint" {
  type = string
}

variable "mysql_user" {
  type = string
}

variable "mysql_password" {
  type      = string
  sensitive = true
}

variable "pdns_api_key" {
  type      = string
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

variable "ssh_public_key" {
  type = string
}
