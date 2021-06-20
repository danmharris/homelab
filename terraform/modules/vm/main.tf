terraform {
  required_providers {
    powerdns = {
      source = "pan-net/powerdns"
      version = "1.4.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.1"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.name
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
  name    = "${var.name}.dnhrrs.xyz."
  type    = "A"
  ttl     = 3600
  records = [var.ip]
}

resource "powerdns_record" "dns-ptr" {
  zone    = "23.10.in-addr.arpa"
  name    = "${join(".",reverse(split(".", var.ip)))}.in-addr.arpa."
  type    = "PTR"
  ttl     = 3600
  records = ["${var.name}.dnhrrs.xyz."]
}
