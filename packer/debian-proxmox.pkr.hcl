packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_url" {
  type = string
}
variable "proxmox_username" {
  type = string
}
variable "proxmox_password" {
  type = string
}
variable "proxmox_node" {
  type = string
}

locals {
  date = formatdate("YYYYMMDD", timestamp())
}

source "proxmox-iso" "proxmox" {
  proxmox_url              = var.proxmox_url
  insecure_skip_tls_verify = true
  username                 = var.proxmox_username
  password                 = var.proxmox_password

  node   = var.proxmox_node
  pool   = "templates"
  memory = 1024
  os     = "l26"
  bios   = "ovmf"
  efi_config {
    efi_storage_pool = "local-lvm"
  }
  qemu_agent              = true
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    vlan_tag = "20"
    firewall = true
  }
  disks {
    type              = "virtio"
    disk_size         = "30G"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm-thin"
    format            = "raw"
  }

  unmount_iso    = true
  http_directory = "http"
  boot_wait      = "15s"
  boot_command = [
    "<down>e<wait>",
    "<down><down><down><end><wait>",
    "auto=true priority=critical <wait>",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
    "<f10><wait>",
  ]

  ssh_username = "packer"
  ssh_password = "packer"
  ssh_timeout  = "15m"
}

build {
  name = "debian"

  source "proxmox-iso.proxmox" {
    name = "bookworm"

    iso_file             = "local:iso/debian-12.1.0-amd64-netinst.iso"
    template_name        = "debian12-${local.date}"
    template_description = "Debian 12, generated by Packer"
  }

  provisioner "shell" {
    script          = "scripts/provision.sh"
    execute_command = "echo 'packer' | sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
  }
}
