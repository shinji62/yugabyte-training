output "google_network_name" {
  value       = module.gcp-vpc.network_name
  description = "the name of the google network"
}

output "google_subnet_self_links" {
  value       = module.gcp-vpc.subnets_self_links
  description = "the self links of the subnets of the google network to give access to the vpn"
}

output "node_on_prem" {
  description = "Node for on prem cloud provider testing"
  value = { for v in google_compute_instance.yugabyte_node_instances :
    v.name => {
      "az"         = v.zone
      "public_ip"  = flatten(flatten(v.network_interface[*].access_config[*].nat_ip))
      "private_ip" = flatten(flatten(v.network_interface[*].network_ip))
    }
  }
}
