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