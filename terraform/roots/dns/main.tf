terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.5.0"
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

locals {
  authdns_ips = toset(["10.23.20.104"])
  recdns_ips  = toset(["10.23.20.101"])
}

resource "random_pet" "authdns_name" {
  for_each = local.authdns_ips
  length = 2
}

resource "proxmox_vm_qemu" "authdns" {
  for_each    = local.authdns_ips
  name        = random_pet.authdns_name[each.value].id
  desc        = "Authoritative DNS server"
  target_node = "tangor"
  clone       = "debian11"

  cores = 1
  memory = 512

  agent = 1
  boot  = "order=scsi0;ide2;net0"

  os_type   = "cloud-init"
  ipconfig0 = "ip=${each.value}/24,gw=10.23.20.1"
  sshkeys   = var.ssh_public_key

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "10G"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 20
  }

  provisioner "local-exec" {
    working_dir = "../../../ansible/"
    command = "ansible-playbook -l ${each.value} site.yaml"
  }
}

resource "random_pet" "recdns_name" {
  for_each = local.recdns_ips
  length = 2
}

resource "proxmox_vm_qemu" "recdns" {
  for_each    = local.recdns_ips
  name        = random_pet.recdns_name[each.value].id
  desc        = "Authoritative DNS server"
  target_node = "tangor"
  clone       = "debian11"

  cores = 1
  memory = 512

  agent = 1
  boot  = "order=scsi0;ide2;net0"

  os_type   = "cloud-init"
  ipconfig0 = "ip=${each.value}/24,gw=10.23.20.1"
  sshkeys   = var.ssh_public_key

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "10G"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 20
  }

  provisioner "local-exec" {
    working_dir = "../../../ansible/"
    command = "ansible-playbook -l ${each.value} site.yaml"
  }
}
