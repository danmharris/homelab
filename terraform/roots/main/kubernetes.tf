module "k8s_cluster" {
  source         = "../../modules/kubernetes"
  controller_ips = ["10.23.20.30"]
  node_ips       = ["10.23.20.31","10.23.20.32"]
  ssh_public_key = var.ssh_public_key
  template       = "debian10"
}

// NFS node
resource "random_pet" "nfs_name" {
  length   = 2
}

resource "proxmox_vm_qemu" "nfs" {
  name        = random_pet.nfs_name.id
  desc        = "NFS server"
  target_node = "tangor"
  clone       = "debian11"

  cores  = 2
  memory = 1024

  agent = 1
  boot  = "order=scsi0;ide2;net0"

  os_type   = "cloud-init"
  ipconfig0 = "ip=10.23.20.14/24,gw=10.23.20.1"
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
    command     = "ansible-playbook -l 10.23.20.14 site.yaml"
  }
}

resource "powerdns_record" "nfs_a" {
  zone     = "dnhrrs.xyz"
  name     = "${proxmox_vm_qemu.nfs.name}.vm.dnhrrs.xyz."
  type     = "A"
  ttl      = 3600
  records  = [proxmox_vm_qemu.nfs.default_ipv4_address]
}

resource "powerdns_record" "vm_ptr" {
  zone     = "23.10.in-addr.arpa"
  name     = "${join(".", reverse(split(".", proxmox_vm_qemu.nfs.default_ipv4_address)))}.in-addr.arpa."
  type     = "PTR"
  ttl      = 3600
  records  = ["${proxmox_vm_qemu.nfs.name}.vm.dnhrrs.xyz."]
}

// Ingress
resource "random_id" "ingress_name" {
  byte_length = 3
}

resource "powerdns_record" "ingress_a" {
  zone    = "dnhrrs.xyz"
  name    = "ingress-${random_id.ingress_name.hex}.k8s.dnhrrs.xyz."
  type    = "A"
  ttl     = 3600
  records = ["10.44.0.10"]
}

resource "powerdns_record" "bookstack_cname" {
  zone    = "dnhrrs.xyz"
  name    = "bookstack.dnhrrs.xyz."
  type    = "CNAME"
  ttl     = 3600
  records = [powerdns_record.ingress_a.name]
}

resource "powerdns_record" "photoprism_cname" {
  zone    = "dnhrrs.xyz"
  name    = "photoprism.dnhrrs.xyz."
  type    = "CNAME"
  ttl     = 3600
  records = [powerdns_record.ingress_a.name]
}

resource "powerdns_record" "prometheus_cname" {
  zone    = "dnhrrs.xyz"
  name    = "prometheus.dnhrrs.xyz."
  type    = "CNAME"
  ttl     = 3600
  records = [powerdns_record.ingress_a.name]
}
