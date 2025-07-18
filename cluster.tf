resource "scaleway_k8s_cluster" "cluster" {
  name                        = "grp-4"
  version                     = "1.32.3"
  cni                         = "cilium"
  private_network_id          = scaleway_vpc_private_network.main.id
  delete_additional_resources = false
}

resource "scaleway_k8s_pool" "pool" {
  cluster_id  = scaleway_k8s_cluster.cluster.id
  name        = "grp-4-pool-1"
  node_type   = "DEV1-M"
  size        = 1
  autoscaling = true
  autohealing = true
}

resource "null_resource" "kubeconfig" {
  depends_on = [scaleway_k8s_pool.pool] # at least one pool here
  triggers = {
    host                   = scaleway_k8s_cluster.cluster.kubeconfig[0].host
    token                  = scaleway_k8s_cluster.cluster.kubeconfig[0].token
    cluster_ca_certificate = scaleway_k8s_cluster.cluster.kubeconfig[0].cluster_ca_certificate
  }
}
