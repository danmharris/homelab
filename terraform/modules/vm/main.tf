terraform {
  required_providers {
    powerdns = {
      source = "pan-net/powerdns"
      version = "1.4.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

resource "random_pet" "name" {
  length = 2
}

locals {
  name = var.name != "" ? var.name : random_pet.name.id
}

resource "proxmox_vm_qemu" "vm" {
  name        = local.name
  desc        = var.desc
  target_node = var.node
  clone       = var.template

  cores  = var.cores
  memory = var.memory

  agent = 1
  boot  = "order=scsi0;ide2;net0"

  os_type   = "cloud-init"
  ipconfig0 = "ip=${var.ip}/24,gw=${var.gw}"
  sshkeys   = var.ssh_public_key

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "${var.disk}G"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = var.vlan
  }
}

resource "powerdns_record" "dns-a" {
  zone    = "dnhrrs.xyz"
  name    = "${local.name}.dnhrrs.xyz."
  type    = "A"
  ttl     = 3600
  records = [var.ip]
}

resource "powerdns_record" "dns-ptr" {
  zone    = "23.10.in-addr.arpa"
  name    = "${join(".",reverse(split(".", var.ip)))}.in-addr.arpa."
  type    = "PTR"
  ttl     = 3600
  records = ["${local.name}.dnhrrs.xyz."]
}
