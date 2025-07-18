resource "scaleway_vpc" "main" {
  name = "kubernetes-vpc-grp4"
}

resource "scaleway_vpc_private_network" "main" {
  name     = "Private-network-grp4"
  vpc_id   = scaleway_vpc.main.id
}

resource "scaleway_vpc_public_gateway_ip" "main" {
  count      = 1
}

resource "scaleway_vpc_public_gateway" "main" {
  name           = "gateway-grp4"
  type           = "VPC-GW-S"
  ip_id          = scaleway_vpc_public_gateway_ip.main[0].id
}

resource "scaleway_vpc_gateway_network" "main" {
  gateway_id         = scaleway_vpc_public_gateway.main.id
  private_network_id = scaleway_vpc_private_network.main.id
  enable_masquerade  = true
  ipam_config {
    push_default_route = true
  }
}