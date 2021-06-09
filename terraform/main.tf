resource "proxmox_vm_qemu" "westie" {
  name        = "westie"
  desc        = "Authoritative DNS server"
  target_node = "tangor"
  clone       = "debian10"

  agent = 1
  boot  = var.proxmox_boot_order

  os_type   = "cloud-init"
  ipconfig0 = "ip=10.23.20.100/24,gw=10.23.20.1"
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
}

resource "proxmox_vm_qemu" "scotty" {
  name        = "scotty"
  desc        = "Recursive DNS server"
  target_node = "tangor"
  clone       = "debian10"

  agent = 1
  boot  = var.proxmox_boot_order

  os_type   = "cloud-init"
  ipconfig0 = "ip=10.23.20.101/24,gw=10.23.20.1"
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
}
