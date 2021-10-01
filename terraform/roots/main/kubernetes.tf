module "k8s_cluster" {
  source         = "../../modules/kubernetes"
  controller_ips = ["10.23.20.30"]
  node_ips       = ["10.23.20.31","10.23.20.32"]
  ssh_public_key = var.ssh_public_key
  template       = "debian10"
}
