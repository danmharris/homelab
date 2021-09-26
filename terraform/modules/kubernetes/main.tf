terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.4.0"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.7.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

locals {
  controller_ips = toset(var.controller_ips)
  node_ips       = toset(var.node_ips)
  all_ips        = setunion(local.controller_ips, local.node_ips)
}

resource "random_pet" "vm_name" {
  for_each = local.all_ips
  length   = 2
}

resource "proxmox_vm_qemu" "controller" {
  for_each    = local.controller_ips
  name        = random_pet.vm_name[each.value].id
  desc        = "Kubernetes controller"
  target_node = var.node
  clone       = var.template

  cores  = 2
  memory = 3072

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
    command     = "ansible-playbook -l ${each.value} site.yaml"
  }
}

resource "proxmox_vm_qemu" "node" {
  for_each    = local.node_ips
  name        = random_pet.vm_name[each.value].id
  desc        = "Kubernetes node"
  target_node = var.node
  clone       = var.template

  cores  = 2
  memory = 3072

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

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "100G"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 20
  }

  provisioner "local-exec" {
    working_dir = "../../../ansible/"
    command     = "ansible-playbook -l '${var.controller_ips[0]},${each.value}' site.yaml"
  }
}

resource "powerdns_record" "vm_a" {
  for_each = merge(proxmox_vm_qemu.controller, proxmox_vm_qemu.node)
  zone     = "dnhrrs.xyz"
  name     = "${each.value.name}.vm.dnhrrs.xyz."
  type     = "A"
  ttl      = 3600
  records  = [each.value.default_ipv4_address]
}

resource "powerdns_record" "vm_ptr" {
  for_each = merge(proxmox_vm_qemu.controller, proxmox_vm_qemu.node)
  zone     = "23.10.in-addr.arpa"
  name     = "${join(".", reverse(split(".", each.value.default_ipv4_address)))}.in-addr.arpa."
  type     = "PTR"
  ttl      = 3600
  records  = ["${each.value.name}.vm.dnhrrs.xyz."]
}
