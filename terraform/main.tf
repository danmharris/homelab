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

resource "powerdns_record" "dns-a" {
  zone    = "dnhrrs.xyz"
  name    = "ha.dnhrrs.xyz."
  type    = "A"
  ttl     = 3600
  records = ["10.23.30.5"]
}

resource "powerdns_record" "dns-ptr" {
  zone    = "23.10.in-addr.arpa"
  name    = "5.30.23.10.in-addr.arpa."
  type    = "PTR"
  ttl     = 3600
  records = ["ha.dnhrrs.xyz."]
}
