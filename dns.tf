data "scaleway_domain_zone" "main" {
  domain    = "slashops.fr"
  subdomain = "grp_4.esgi"
}

resource "scaleway_domain_record" "www" {
  dns_zone = data.scaleway_domain_zone.main.id
  name     = "@"
  type     = "A"
  data     = scaleway_lb_ip.nginx_ip.ip_address
  ttl      = 3600
}