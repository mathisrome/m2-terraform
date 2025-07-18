resource "scaleway_vpc" "main" {
  name = "grp-4-kubernetes-vpc"

  tags = ["grp-4-vpc"]
}

resource "scaleway_vpc_private_network" "main" {
  name   = "grp-4-private-network"
  vpc_id = scaleway_vpc.main.id

  tags = ["grp-4-private-network"]
}

resource "scaleway_vpc_public_gateway_ip" "main" {
  count = 1
}

resource "scaleway_vpc_public_gateway" "main" {
  name  = "grp_4_gateway"
  type  = "VPC-GW-S"
  ip_id = scaleway_vpc_public_gateway_ip.main[0].id
  tags  = ["grp-4-public-gateway"]
}

resource "scaleway_vpc_gateway_network" "main" {
  gateway_id         = scaleway_vpc_public_gateway.main.id
  private_network_id = scaleway_vpc_private_network.main.id
  enable_masquerade  = true
  ipam_config {
    push_default_route = true
  }
}