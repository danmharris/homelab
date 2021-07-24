variable "cores" {
  type        = number
  description = "Number of cores. Defaults to 1"
  default     = 1
}

variable "desc" {
  type        = string
  description = "Purpose of VM"
}

variable "disk" {
  type        = number
  description = "Disk size in GB. Defaults to 10"
  default     = 10
}

variable "gw" {
  type        = string
  description = "IPv4 default gateway. Defaults to 10.23.20.1"
  default     = "10.23.20.1"
}

variable "ip" {
  type        = string
  description = "IPv4 address"
}

variable "memory" {
  type        = number
  description = "Memory size in MB. Defaults to 512"
  default     = 512
}

variable "name" {
  type        = string
  description = "Name of VM. Will also be used as A record"
  default     = ""
}

variable "node" {
  type        = string
  description = "Proxmox node to put resource on"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for dnhrrs user"
}

variable "template" {
  type        = string
  description = "VM to clone from. Defaults to debian10"
  default     = "debian10"
}

variable "vlan" {
  type        = number
  description = "VLAN to put VM on. Defaults to 20"
  default     = 20
}
