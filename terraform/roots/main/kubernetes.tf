module "k8s_cluster" {
  source         = "../../modules/kubernetes"
  controller_ips = ["10.23.20.100"]
  node_ips       = ["10.23.20.102","10.23.20.103"]
  ssh_public_key = var.ssh_public_key
}
