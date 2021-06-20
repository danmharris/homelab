module "westie_vm" {
  source         = "./modules/vm"
  name           = "westie"
  desc           = "Authoritative DNS server"
  node           = "tangor"
  ip             = "10.23.20.100"
  ssh_public_key = var.ssh_public_key
}

module "scotty_vm" {
  source         = "./modules/vm"
  name           = "scotty"
  desc           = "Recursive DNS server"
  node           = "tangor"
  ip             = "10.23.20.101"
  ssh_public_key = var.ssh_public_key
}

module "dalmatian_vm" {
  source         = "./modules/vm"
  name           = "dalmatian"
  desc           = "MySQL server"
  node           = "tangor"
  ip             = "10.23.20.102"
  ssh_public_key = var.ssh_public_key
  memory         = 1024
}
