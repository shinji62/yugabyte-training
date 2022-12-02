
/*
 * ---------- Google ------------
 */

resource "aws_customer_gateway" "google-1" {
  bgp_asn    = 65000
  ip_address = google_compute_ha_vpn_gateway.aws-gateway.vpn_interfaces[0].ip_address
  type       = "ipsec.1"

  tags = {
    Name = "${local.name_prefix}-gw-gcp-1"
  }
}


resource "aws_customer_gateway" "google-2" {
  bgp_asn    = 65000
  ip_address = google_compute_ha_vpn_gateway.aws-gateway.vpn_interfaces[1].ip_address
  type       = "ipsec.1"

  tags = {
    Name = "${local.name_prefix}-gw-gcp-2"
  }
}

resource "aws_vpn_connection" "google-1" {
  vpn_gateway_id                       = var.aws_vpn_gateway_id
  customer_gateway_id                  = aws_customer_gateway.google-1.id
  type                                 = "ipsec.1"
  static_routes_only                   = false
  tunnel1_phase1_encryption_algorithms = var.aws_vpn_configs.encryption_algorithms
  tunnel2_phase1_encryption_algorithms = var.aws_vpn_configs.encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.aws_vpn_configs.integrity_algorithms
  tunnel2_phase1_integrity_algorithms  = var.aws_vpn_configs.integrity_algorithms
  tunnel1_phase1_dh_group_numbers      = var.aws_vpn_configs.dh_group_numbers
  tunnel2_phase1_dh_group_numbers      = var.aws_vpn_configs.dh_group_numbers
  tunnel1_phase2_encryption_algorithms = var.aws_vpn_configs.encryption_algorithms
  tunnel2_phase2_encryption_algorithms = var.aws_vpn_configs.encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.aws_vpn_configs.integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = var.aws_vpn_configs.integrity_algorithms
  tunnel1_phase2_dh_group_numbers      = var.aws_vpn_configs.dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = var.aws_vpn_configs.dh_group_numbers

  tags = {
    Name = "${local.name_prefix}-gcp-vpn-con-1"
  }
}

resource "aws_vpn_connection" "google-2" {
  vpn_gateway_id                       = var.aws_vpn_gateway_id
  customer_gateway_id                  = aws_customer_gateway.google-2.id
  type                                 = "ipsec.1"
  static_routes_only                   = false
  tunnel1_phase1_encryption_algorithms = var.aws_vpn_configs.encryption_algorithms
  tunnel2_phase1_encryption_algorithms = var.aws_vpn_configs.encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.aws_vpn_configs.integrity_algorithms
  tunnel2_phase1_integrity_algorithms  = var.aws_vpn_configs.integrity_algorithms
  tunnel1_phase1_dh_group_numbers      = var.aws_vpn_configs.dh_group_numbers
  tunnel2_phase1_dh_group_numbers      = var.aws_vpn_configs.dh_group_numbers
  tunnel1_phase2_encryption_algorithms = var.aws_vpn_configs.encryption_algorithms
  tunnel2_phase2_encryption_algorithms = var.aws_vpn_configs.encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.aws_vpn_configs.integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = var.aws_vpn_configs.integrity_algorithms
  tunnel1_phase2_dh_group_numbers      = var.aws_vpn_configs.dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = var.aws_vpn_configs.dh_group_numbers
  tags = {
    Name = "${local.name_prefix}-gcp-vpn-con-2"
  }
}

/*
 * ---------- Azure ------------
 */

// Deploy Customer Gateways
resource "aws_customer_gateway" "azure_1" {
  ip_address = data.azurerm_public_ip.azure_1.ip_address
  bgp_asn    = 65515
  type       = "ipsec.1"

  tags = merge(var.default_tags, {
    Name = "${local.name_prefix}-gw-azure-1"
  })

  lifecycle {
    ignore_changes = [ip_address]
  }

  depends_on = [
    azurerm_public_ip.azure_1
  ]
}
resource "aws_customer_gateway" "azure_2" {
  ip_address = data.azurerm_public_ip.azure_2.ip_address
  bgp_asn    = 65515
  type       = "ipsec.1"

  tags = merge(var.default_tags, {
    Name = "${local.name_prefix}-gw-azure-2"
  })

  lifecycle {
    ignore_changes = [ip_address]
  }

  depends_on = [
    azurerm_public_ip.azure_2
  ]
}

// Create VPN Connections
resource "aws_vpn_connection" "azure_1" {
  vpn_gateway_id      = var.aws_vpn_gateway_id
  customer_gateway_id = aws_customer_gateway.azure_1.id

  type                = "ipsec.1"
  tunnel1_inside_cidr = var.aws_vpn_bgp_peering_cidr_1
  tunnel2_inside_cidr = var.aws_vpn_bgp_peering_cidr_2

  tags = merge(var.default_tags, {
    Name = "${local.name_prefix}-azure-vpn-con-1"
  })
}
resource "aws_vpn_connection" "azure_2" {
  vpn_gateway_id      = var.aws_vpn_gateway_id
  customer_gateway_id = aws_customer_gateway.azure_2.id

  type                = "ipsec.1"
  tunnel1_inside_cidr = var.aws_vpn_bgp_peering_cidr_3
  tunnel2_inside_cidr = var.aws_vpn_bgp_peering_cidr_4

  tags = merge(var.default_tags, {
    Name = "${local.name_prefix}-azure-vpn-con-2"
  })
}
