data "google_compute_subnetwork" "subnet" {
  count     = length(var.google_subnet_self_links)
  self_link = var.google_subnet_self_links[count.index]
}


resource "google_compute_ha_vpn_gateway" "aws-gateway" {
  name    = "${local.name_prefix}-ha-vpn-gw-to-aws"
  project = var.google_project_id
  network = var.google_network_name
}

resource "google_compute_router" "router" {
  provider    = google
  name        = "${local.name_prefix}-cr-to-aws-ha-vpn-${var.aws_region}"
  network     = var.google_network_name
  description = "Google to AWS for AWS region ${var.aws_region}"
  bgp {
    asn = 65000
  }
}


resource "google_compute_vpn_tunnel" "tunnels" {
  provider                        = google
  for_each                        = local.external_vpn_gateway_interfaces
  name                            = "tunnel${each.key}-${google_compute_router.router.name}"
  description                     = "Tunnel to AWS - HA VPN interface ${each.key} to AWS interface ${each.value.tunnel_address}"
  router                          = google_compute_router.router.self_link
  ike_version                     = 2
  shared_secret                   = each.value.shared_secret
  vpn_gateway                     = google_compute_ha_vpn_gateway.aws-gateway.self_link
  vpn_gateway_interface           = each.value.vpn_gateway_interface
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.self_link
  peer_external_gateway_interface = each.key
}

resource "google_compute_router_interface" "interfaces" {
  provider   = google
  for_each   = local.external_vpn_gateway_interfaces
  name       = "interface${each.key}-${google_compute_router.router.name}"
  router     = google_compute_router.router.name
  ip_range   = each.value.cgw_inside_address
  vpn_tunnel = google_compute_vpn_tunnel.tunnels[each.key].name
}

resource "google_compute_router_peer" "router_peers" {
  provider        = google
  for_each        = local.external_vpn_gateway_interfaces
  name            = "peer${each.key}-${google_compute_router.router.name}"
  router          = google_compute_router.router.name
  peer_ip_address = each.value.vgw_inside_address
  peer_asn        = each.value.asn
  interface       = google_compute_router_interface.interfaces[each.key].name
}


resource "google_compute_external_vpn_gateway" "external_gateway" {
  provider        = google
  name            = "${local.name_prefix}-aws-${var.aws_region}"
  redundancy_type = "FOUR_IPS_REDUNDANCY"
  description     = "AWS  in AWS region ${var.aws_region}"

  dynamic "interface" {
    for_each = local.external_vpn_gateway_interfaces
    content {
      id         = interface.key
      ip_address = interface.value["tunnel_address"]
    }
  }
}
