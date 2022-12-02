locals {
  name_prefix = var.resource_prefix
  ha_vpn_interfaces_ips = [
    for x in google_compute_ha_vpn_gateway.aws-gateway.vpn_interfaces :
    lookup(x, "ip_address")
  ]
  external_vpn_gateway_interfaces = {
    "0" = {
      tunnel_address        = aws_vpn_connection.google-1.tunnel1_address
      vgw_inside_address    = aws_vpn_connection.google-1.tunnel1_vgw_inside_address
      asn                   = aws_vpn_connection.google-1.tunnel1_bgp_asn
      cgw_inside_address    = "${aws_vpn_connection.google-1.tunnel1_cgw_inside_address}/30"
      shared_secret         = aws_vpn_connection.google-1.tunnel1_preshared_key
      vpn_gateway_interface = 0
    },
    "1" = {
      tunnel_address        = aws_vpn_connection.google-1.tunnel2_address
      vgw_inside_address    = aws_vpn_connection.google-1.tunnel2_vgw_inside_address
      asn                   = aws_vpn_connection.google-1.tunnel2_bgp_asn
      cgw_inside_address    = "${aws_vpn_connection.google-1.tunnel2_cgw_inside_address}/30"
      shared_secret         = aws_vpn_connection.google-1.tunnel2_preshared_key
      vpn_gateway_interface = 0
    },
    "2" = {
      tunnel_address        = aws_vpn_connection.google-2.tunnel1_address
      vgw_inside_address    = aws_vpn_connection.google-2.tunnel1_vgw_inside_address
      asn                   = aws_vpn_connection.google-2.tunnel1_bgp_asn
      cgw_inside_address    = "${aws_vpn_connection.google-2.tunnel1_cgw_inside_address}/30"
      shared_secret         = aws_vpn_connection.google-2.tunnel1_preshared_key
      vpn_gateway_interface = 1
    },
    "3" = {
      tunnel_address        = aws_vpn_connection.google-2.tunnel2_address
      vgw_inside_address    = aws_vpn_connection.google-2.tunnel2_vgw_inside_address
      asn                   = aws_vpn_connection.google-2.tunnel2_bgp_asn
      cgw_inside_address    = "${aws_vpn_connection.google-2.tunnel2_cgw_inside_address}/30"
      shared_secret         = aws_vpn_connection.google-2.tunnel2_preshared_key
      vpn_gateway_interface = 1
    },
  }

  azure_external_vpn_gateway_interfaces = {
    "0" = {
      local_network_gateway_id = azurerm_local_network_gateway.azure["0"].id
      shared_key               = aws_vpn_connection.azure_1.tunnel1_preshared_key
    },
    "1" = {
      local_network_gateway_id = azurerm_local_network_gateway.azure["1"].id
      shared_key               = aws_vpn_connection.azure_1.tunnel2_preshared_key
    },
    "2" = {
      local_network_gateway_id = azurerm_local_network_gateway.azure["2"].id
      shared_key               = aws_vpn_connection.azure_2.tunnel1_preshared_key
    },
    "3" = {
      local_network_gateway_id = azurerm_local_network_gateway.azure["3"].id
      shared_key               = aws_vpn_connection.azure_2.tunnel2_preshared_key
    },
  }

  azure_local_network_gateway = {
    "0" = {
      bgp_peering_address = var.aws_vpn_bgp_peering_address_1
      gateway_address     = aws_vpn_connection.azure_1.tunnel1_address

    },
    "1" = {
      bgp_peering_address = var.aws_vpn_bgp_peering_address_2
      gateway_address     = aws_vpn_connection.azure_1.tunnel2_address

    },
    "2" = {
      bgp_peering_address = var.aws_vpn_bgp_peering_address_3
      gateway_address     = aws_vpn_connection.azure_2.tunnel1_address

    },
    "3" = {
      bgp_peering_address = var.aws_vpn_bgp_peering_address_4
      gateway_address     = aws_vpn_connection.azure_2.tunnel2_address

    },
  }
}
