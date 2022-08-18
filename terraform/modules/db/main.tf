terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.4.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

locals {
  replica_ips = toset(var.replica_ips)
}

resource "random_pet" "replica_name" {
  for_each = local.replica_ips
  length   = 2
}

resource "proxmox_vm_qemu" "replica" {
  for_each    = local.replica_ips
  name        = random_pet.replica_name[each.value].id
  desc        = "MySQL Replica for cluster-${random_id.cluster_name.hex}"
  target_node = var.node
  clone       = var.template

  cores  = var.cores
  memory = var.ram

  agent = 1
  boot  = "order=scsi0;ide2;net0"

  os_type   = "cloud-init"
  ipconfig0 = "ip=${each.value}/24,gw=10.23.20.1"
  sshkeys   = var.ssh_public_key

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "${var.disk}G"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 20
  }

  provisioner "local-exec" {
    working_dir = "../../../ansible/"
    command     = "ansible-playbook -l ${each.value} site.yaml"
  }
}

resource "powerdns_record" "replica_a" {
  for_each = proxmox_vm_qemu.replica
  zone     = "dnhrrs.xyz"
  name     = "${each.value.name}.vm.dnhrrs.xyz."
  type     = "A"
  ttl      = 3600
  records  = [each.value.default_ipv4_address]
}

resource "powerdns_record" "replica_ptr" {
  for_each = proxmox_vm_qemu.replica
  zone     = "23.10.in-addr.arpa"
  name     = "${join(".", reverse(split(".", each.value.default_ipv4_address)))}.in-addr.arpa."
  type     = "PTR"
  ttl      = 3600
  records  = ["${each.value.name}.vm.dnhrrs.xyz."]
}

resource "random_id" "cluster_name" {
  byte_length = 3
}

resource "powerdns_record" "cluster_cname" {
  zone    = "dnhrrs.xyz"
  name    = "cluster-${random_id.cluster_name.hex}.db.dnhrrs.xyz."
  type    = "CNAME"
  ttl     = 3600
  records = [powerdns_record.replica_a[var.primary_ip].name]
}
