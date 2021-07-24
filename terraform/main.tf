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

module "db_0_vm" {
  source         = "./modules/vm"
  desc           = "MySQL server primary"
  node           = "tangor"
  ip             = "10.23.20.102"
  ssh_public_key = var.ssh_public_key
  memory         = 1024
}

module "db_1_vm" {
  source         = "./modules/vm"
  desc           = "MySQL server replica"
  node           = "tangor"
  ip             = "10.23.20.103"
  ssh_public_key = var.ssh_public_key
  memory         = 1024
}
