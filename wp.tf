resource "helm_release" "wordpress" {
  name      = "grp-4-wordpress"
  namespace = "kube-system"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"

  set = [
    {
      name  = "service.type"
      value = "ClusterIP"
    },
    {
      name  = "ingress.enabled"
      value = "true"
    },
    {
      name  = "ingress.ingressClassName"
      value = "nginx"
    },
    {
      name  = "ingress.hostname"
      value = data.scaleway_domain_zone.main.id
    },
    {
      name  = "wordpressUsername"
      value = "admin"
    },
    {
      name  = "wordpressPassword"
      value = "SecurePassword123!"
    },
    {
      name  = "wordpressEmail"
      value = "admin@${data.scaleway_domain_zone.main.id}"
    },
    {
      name  = "wordpressFirstName"
      value = "Admin"
    },
    {
      name  = "wordpressLastName"
      value = "GRP4"
    },
    {
      name  = "wordpressBlogName"
      value = "Groupe 4 ESGI WordPress"
    },
    {
      name  = "mariadb.enabled"
      value = "true"
    },
    {
      name  = "mariadb.auth.rootPassword"
      value = "SecureDatabasePassword123!"
    },
    {
      name  = "mariadb.auth.database"
      value = "wordpress"
    },
    {
      name  = "mariadb.auth.username"
      value = "wordpress"
    },
    {
      name  = "mariadb.auth.password"
      value = "WordPressDBPassword123!"
    },
    {
      name  = "mariadb.primary.persistence.enabled"
      value = "true"
    },
    {
      name  = "mariadb.primary.persistence.size"
      value = "8Gi"
    },
    {
      name  = "persistence.enabled"
      value = "true"
    },
    {
      name  = "persistence.size"
      value = "10Gi"
    },
    {
      name  = "resources.requests.memory"
      value = "512Mi"
    },
    {
      name  = "resources.requests.cpu"
      value = "300m"
    },
    {
      name  = "resources.limits.memory"
      value = "1Gi"
    },
    {
      name  = "resources.limits.cpu"
      value = "500m"
    }
  ]

  depends_on = [helm_release.nginx_ingress]
}