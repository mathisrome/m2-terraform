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

resource "scaleway_lb_ip" "nginx_ip" {}

resource "helm_release" "nginx_ingress" {
  name      = "grp-4-nginx-ingress"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set = [
    {
      name  = "controller.service.loadBalancerIP"
      value = scaleway_lb_ip.nginx_ip.ip_address
    },

    // enable proxy protocol to get client ip addr instead of loadbalancer one
    {
      name  = "controller.config.use-proxy-protocol"
      value = "true"
    },

    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-proxy-protocol-v2"
      value = "true"
    },

    // indicates in which zone to create the loadbalancer
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-zone"
      value = scaleway_lb_ip.nginx_ip.zone
    },

    // enable to avoid node forwarding
    {
      name  = "controller.service.externalTrafficPolicy"
      value = "Local"
    }
  ]
  // enable this annotation to use cert-manager
  //set {
  //  name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/scw-loadbalancer-use-hostname"
  //  value = "true"
  //}
}