# # Setup YBA using Installer
resource "yba_installer" "install" {
  provider                  = yba.unauthenticated
  ssh_host_ip               = local.yba_public_ip
  ssh_user                  = var.yba_ssh_user
  ssh_private_key_file_path = var.yba_ssh_private_key_path
  yba_license_file          = var.yba_license_file_path
  yba_version               = var.yba_version_number
  depends_on                = [google_compute_instance.yugabyte_anywhere_instances]
}



# # ### Config YBA
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
  url = "https://${local.yba_public_ip}/api/v1/app_version"

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


resource "yba_cloud_provider" "gcp" {
  code     = "gcp"
  provider = yba.authenticated
  name     = "gcpProvider"
  dynamic "regions" {
    for_each = module.gcp-vpc.subnets
    content {
      code = split("/", regions.key)[0]
      name = split("/", regions.key)[0]
      zones {
        subnet = split("/", regions.key)[1]
      }
    }

  }
  gcp_config_settings {
    use_host_vpc         = true
    project_id           = var.project_id
    use_host_credentials = true
    yb_firewall_tags     = "yb-db-node"
  }
  depends_on = [module.gcp-vpc, yba_customer_resource.customer]

}




# // Provider key version
data "yba_provider_key" "gcp_key" {
  provider_id = yba_cloud_provider.gcp.id
  provider    = yba.authenticated
}

// To fetch default YBDB version
data "yba_release_version" "release_version" {
  provider   = yba.authenticated
  depends_on = [yba_installer.install, yba_customer_resource.customer]
}


resource "yba_universe" "gcprf3" {
  provider = yba.authenticated
  clusters {
    cluster_type = "PRIMARY"
    user_intent {
      # tserver_gflags = {
      #   yb_enable_read_committed_isolation = true
      # }
      # master_gflags = {
      #   yb_enable_read_committed_isolation = true
      # }
      universe_name      = "gcp-rf3-test"
      provider_type      = yba_cloud_provider.gcp.code
      provider           = yba_cloud_provider.gcp.id
      region_list        = yba_cloud_provider.gcp.regions[*].uuid
      num_nodes          = 3
      replication_factor = 3
      instance_type      = "n1-standard-1"
      device_info {
        num_volumes  = 1
        volume_size  = 375
        storage_type = "Persistent"
      }
      use_time_sync       = true
      enable_ysql         = true
      yb_software_version = data.yba_release_version.release_version.id
      access_key_code     = data.yba_provider_key.gcp_key.id
    }
  }
  communication_ports {}
  depends_on = [yba_installer.install, yba_customer_resource.customer]
}


# resource "yba_storage_config_resource" "storage_config" {
#   provider                 = yba.authenticated
#   name                     = "GCS"
#   backup_location          = "gcs://${google_storage_bucket.backup_bucket.name}"
#   config_name              = "gcp-backup"
# }

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

