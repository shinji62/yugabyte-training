# # Setup YBA using Installer
resource "yba_installer" "install" {
  provider                  = yba.unauthenticated
  ssh_host_ip               = module.aws-vpc-vpn-gw.yba_anywhere_ip
  ssh_user                  = var.yba_ssh_user
  ssh_private_key_file_path = var.yba_ssh_private_key_path
  yba_license_file          = var.yba_license_file_path
  yba_version               = var.yba_version_number
  depends_on                = [module.aws-vpc-vpn-gw, module.azure-vpc-vpn-gw, module.gcp-vpc-vpn-gw, module.vpn]
}



### Config YBA
resource "yba_customer_resource" "customer" {
  // use unauthenticated provider to create customer
  provider = yba.unauthenticated
  code     = var.yba_customer_code
  email    = var.yba_customer_email
  name     = var.yba_customer_name
  depends_on = [
    checkmate_http_health.example
  ]
}


resource "checkmate_http_health" "example" {
  # This is the url of the endpoint we want to check
  url = "https://${module.aws-vpc-vpn-gw.yba_anywhere_ip}/api/v1/app_version"

  # Will perform an HTTP GET request
  method = "GET"

  # The overall test should not take longer than 5 min
  timeout = 600000

  # Wait 0.1 seconds between attempts
  interval = 1000

  # Expect a status 200 OK
  status_code = 200

  # We want 2 successes in a row
  consecutive_successes = 2
  insecure_tls          = true
  depends_on            = [yba_installer.install]

}



resource "yba_onprem_provider" "onprem" {
  name     = "onpremmulticloud"
  provider = yba.authenticated
  access_keys {
    key_info {
      key_pair_name             = "sshkey"
      ssh_private_key_file_path = var.node_on_prem_private_key_path
    }

  }
  //Load AWS Region first
  regions {
    name = var.aws_region
    dynamic "zones" {
      for_each = module.aws-vpc-vpn-gw.aws_node_on_prem
      content {
        name = module.aws-vpc-vpn-gw.aws_node_on_prem[zones.key].az
      }
    }
  }

  //Load GCP
  regions {
    name = var.gcp_region
    dynamic "zones" {
      for_each = module.gcp-vpc-vpn-gw.node_on_prem
      content {
        name = module.gcp-vpc-vpn-gw.node_on_prem[zones.key].az
      }
    }
  }

  //Load Azure
  regions {
    name = var.azure_location
    dynamic "zones" {
      for_each = module.azure-vpc-vpn-gw.node_on_prem
      content {
        name = module.azure-vpc-vpn-gw.node_on_prem[zones.key].az
      }
    }
  }

  details {
    passwordless_sudo_access = true
    ssh_user                 = "ubuntu"
    skip_provisioning        = false
    install_node_exporter    = true
    air_gap_install          = true
  }

  instance_types {
    instance_type_key {
      instance_type_code = "4vpcu-16gb"
    }
    instance_type_details {
      volume_details_list {
        mount_path     = "/mnt/data"
        volume_size_gb = 100
      }
    }
    mem_size_gb = 15
    num_cores   = 4
  }

  dynamic "node_instances" {
    for_each = module.aws-vpc-vpn-gw.aws_node_on_prem
    content {
      instance_type = "4vpcu-16gb"
      ip            = module.aws-vpc-vpn-gw.aws_node_on_prem[node_instances.key].private_ip
      region        = var.aws_region
      zone          = module.aws-vpc-vpn-gw.aws_node_on_prem[node_instances.key].az
    }
  }

  dynamic "node_instances" {
    for_each = module.gcp-vpc-vpn-gw.node_on_prem
    content {
      instance_type = "4vpcu-16gb"
      ip            = module.gcp-vpc-vpn-gw.node_on_prem[node_instances.key].private_ip[0]
      region        = var.gcp_region
      zone          = module.gcp-vpc-vpn-gw.node_on_prem[node_instances.key].az
    }
  }

  dynamic "node_instances" {
    for_each = module.azure-vpc-vpn-gw.node_on_prem
    content {
      instance_type = "4vpcu-16gb"
      ip            = module.azure-vpc-vpn-gw.node_on_prem[node_instances.key].private_ip
      region        = var.azure_location
      zone          = module.azure-vpc-vpn-gw.node_on_prem[node_instances.key].az
    }
  }

  depends_on = [yba_customer_resource.customer]

}


// Provider key version
data "yba_provider_key" "onprem_key" {
  provider_id = yba_onprem_provider.onprem.id
  provider    = yba.authenticated
}

// To fetch default YBDB version
data "yba_release_version" "release_version" {
  provider   = yba.authenticated
  depends_on = [yba_installer.install, yba_customer_resource.customer]
}



resource "yba_universe" "onprem_universe" {
  provider = yba.authenticated
  clusters {
    cluster_type = "PRIMARY"
    user_intent {
      universe_name      = "multicloud"
      provider_type      = "onprem"
      provider           = yba_onprem_provider.onprem.id
      region_list        = yba_onprem_provider.onprem.regions[*].uuid
      num_nodes          = var.aws_node_on_prem_test + var.gcp_node_on_prem_test + var.azure_node_on_prem_test
      replication_factor = 3
      instance_type      = "4vpcu-16gb"
      device_info {
        num_volumes   = 1
        volume_size   = 100
        storage_class = "standard"
        mount_points  = "/mnt/data"
      }

      enable_ysql                   = true
      enable_node_to_node_encrypt   = true
      enable_client_to_node_encrypt = true
      yb_software_version           = data.yba_release_version.release_version.id
      access_key_code               = data.yba_provider_key.onprem_key.id
    }
  }
  communication_ports {}
  depends_on = [yba_installer.install, yba_customer_resource.customer]
}

resource "yba_storage_config_resource" "storage_config" {
  provider                 = yba.authenticated
  name                     = "S3"
  backup_location          = "s3://${module.r1.backup_bucket}"
  config_name              = "aws-backup"
  use_iam_instance_profile = true
}

# # resource "yba_backups" "universe_backup_schedule_detailed" {
# #   provider            = yba.authenticated
# #   universe_uuid       = yba_universe.awsrf3.id
# #   keyspace            = "MYDATABASE"
# #   storage_config_uuid = yba_storage_config_resource.storage_config.id
# #   time_before_delete  = "24h"
# #   frequency           = "120m"
# #   parallelism         = 8
# #   schedule_name       = "backup-mydb"
# #   backup_type         = "PGSQL_TABLE_TYPE"
# # }


# # resource "yba_user" "my-new-user" {
# #   email    = "myuser@test.com"
# #   password = "mysupersecurepassword"
# #   role     = "ReadOnly"
# # }

