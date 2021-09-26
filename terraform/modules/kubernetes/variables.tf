variable "controller_ips" {
  type        = list(string)
  description = "IPs to use for controllers"
}

variable "node_ips" {
  type        = list(string)
  description = "IPs to use for nodes"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for main user"
}

variable "node" {
  type        = string
  description = "Node to put machines on"
  default     = "tangor"
}

variable "template" {
  type        = string
  description = "Template to build machines from"
  default     = "debian11"
}
