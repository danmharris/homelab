variable "cores" {
  type        = number
  description = "Number of cores per replica"
}

variable "ram" {
  type        = number
  description = "RAM (in MB) per replica"
}

variable "disk" {
  type        = number
  description = "Disk size in GB per replica"
}

variable "replica_ips" {
  type        = list(string)
  description = "IPs to use for replicas"
}

variable "primary_ip" {
  type        = string
  description = "Entry of replica_ips to use as primary"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for main user"
}

variable "node" {
  type        = string
  description = "Node to put replicas on"
  default     = "tangor"
}

variable "template" {
  type        = string
  description = "Template to build replicas from"
  default     = "debian11"
}
