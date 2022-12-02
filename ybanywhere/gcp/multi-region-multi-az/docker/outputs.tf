output "yba_vpc_network_name" {
  description = "Name of the VPC network name"
  value       = module.gcp-vpc.network_name
}

output "yba_regions_subnets" {
  description = "Map of region and subnet formated as region/subnet-name"
  value       = keys(module.gcp-vpc.subnets)
}
output "yba_firewall_tags" {
  description = "Firewall tags needed for yba Cloud providers config"
  value       = google_compute_firewall.yb_anywhere_db_node.source_tags
}

output "yba_public_ip" {
  value = google_compute_instance.yugabyte_anywhere_instances.network_interface[*].access_config[*].nat_ip

}

output "yba_project_name" {
  description = "GCP Project ID"
  value       = var.project_id

}

output "replicated_password" {
  description = "Replicated password to get it please use terraform ouput command "
  value       = local.replicated_password
  sensitive   = true
}

output "node_on_prem" {
  description = "Node for on prem cloud provider testing"
  value = { for v in google_compute_instance.yugabyte_node_instances :
    v.name => {
      "az"        = v.zone
      "public_ip" = flatten(flatten(v.network_interface[*].access_config[*].nat_ip))
    }
  }
}
