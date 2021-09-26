module "k8s_cluster" {
  source         = "../../modules/kubernetes"
  controller_ips = ["10.23.20.100"]
  node_ips       = []
  ssh_public_key = var.ssh_public_key
}
