# Description

This deployment will create a VPC in one region and install YB anywhere to one of them.

# YB Anywhere

* Deployed using Terraform and YBA provider
* Need https://github.com/yugabyte/terraform-provider-yba/pull/185 to be merged

# Limitation

* Backup is not working with Terraform yet because of the use of environment variable

# Run
Make sure you are connected to your GCP account (sso, access key, ...)

1. Variable file 
   Create ".tfvars" file containing the required variable (see example.tfvars)

2. Terraform initialization
 
```shell
terraform init
```
3. Deploy

```shell
terraform plan -var-file=yourvars-file.tfvars -out on-region.tfplan
terraform apply on-region.tfplan
```

# YBA anywhere 
You can now access to YBA by using the `yba_public_ip` output by your terraform.


# Cleaning
```shell
terraform destroy -var-file=yourvars-file.tfvars 
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_checkmate"></a> [checkmate](#requirement\_checkmate) | 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.43.1 |
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.0-dev |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_checkmate"></a> [checkmate](#provider\_checkmate) | 1.5.0 |
| <a name="provider_google"></a> [google](#provider\_google) | 4.43.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_yba.authenticated"></a> [yba.authenticated](#provider\_yba.authenticated) | 0.1.0-dev |
| <a name="provider_yba.unauthenticated"></a> [yba.unauthenticated](#provider\_yba.unauthenticated) | 0.1.0-dev |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp-vpc"></a> [gcp-vpc](#module\_gcp-vpc) | terraform-google-modules/network/google | ~> 5.2 |

## Resources

| Name | Type |
|------|------|
| [checkmate_http_health.example](https://registry.terraform.io/providers/tetratelabs/checkmate/1.5.0/docs/resources/http_health) | resource |
| [google_compute_disk.yba_boot_disk](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/compute_disk) | resource |
| [google_compute_firewall.yb_anywhere_db_node](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.yb_anywhere_inst](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/compute_firewall) | resource |
| [google_compute_instance.yugabyte_anywhere_instances](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/compute_instance) | resource |
| [google_project_iam_member.project](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/project_iam_member) | resource |
| [google_service_account.sa_backup_bucket](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/service_account) | resource |
| [google_service_account.sa_yba_instance](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/service_account) | resource |
| [google_service_account_key.google_key](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/service_account_key) | resource |
| [google_storage_bucket.backup_bucket](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.backup_bucket](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.backup_bucket_sa](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/storage_bucket_iam_member) | resource |
| [null_resource.delay](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.gcs_bucket_random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [yba_cloud_provider.gcp](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/resources/cloud_provider) | resource |
| [yba_customer_resource.customer](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/resources/customer_resource) | resource |
| [yba_installer.install](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/resources/installer) | resource |
| [yba_universe.gcprf3](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/resources/universe) | resource |
| [google_compute_image.ubuntu2004](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/data-sources/compute_image) | data source |
| [yba_provider_key.gcp_key](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/data-sources/provider_key) | data source |
| [yba_release_version.release_version](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/data-sources/release_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sources"></a> [allowed\_sources](#input\_allowed\_sources) | Source ips to restrict traffic, for example ["YOUR\_IP/32"] (Required) | `list(string)` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | List of tags to be applied to every resources (Required) | `map(any)` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP region (default: asia-northeast1) | `string` | `"asia-northeast1"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the YugabyteDB Anywhere node (default: n1-standard-4) | `string` | `"n1-standard-4"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to be used for every created resources, Please use 3-4 char. (Required) | `string` | n/a | yes |
| <a name="input_vm_image"></a> [vm\_image](#input\_vm\_image) | n/a | `string` | `"ubuntu-2004-focal-v20221018"` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size for YugabyteDB Anywhere node (default: 100) | `string` | `"250"` | no |
| <a name="input_yb_port"></a> [yb\_port](#input\_yb\_port) | YB ports | `list(number)` | <pre>[<br>  22,<br>  5433,<br>  7000,<br>  7100,<br>  9000,<br>  9100,<br>  9070,<br>  9300,<br>  9042,<br>  11000,<br>  14000,<br>  18018,<br>  13000,<br>  12000<br>]</pre> | no |
| <a name="input_yba_application_settings_file_path"></a> [yba\_application\_settings\_file\_path](#input\_yba\_application\_settings\_file\_path) | Path the YBA installer application settings file | `string` | n/a | yes |
| <a name="input_yba_customer_code"></a> [yba\_customer\_code](#input\_yba\_customer\_code) | Label for the user. (default: admin). | `string` | `"admin"` | no |
| <a name="input_yba_customer_email"></a> [yba\_customer\_email](#input\_yba\_customer\_email) | Email for the user, which is used for login on the YugabyteDB Anywhere portal. | `string` | n/a | yes |
| <a name="input_yba_customer_name"></a> [yba\_customer\_name](#input\_yba\_customer\_name) | Name of the user. (default: admin) | `string` | n/a | yes |
| <a name="input_yba_license_file_path"></a> [yba\_license\_file\_path](#input\_yba\_license\_file\_path) | Path to the YBA license file | `string` | n/a | yes |
| <a name="input_yba_port"></a> [yba\_port](#input\_yba\_port) | YBA default ports | `list(number)` | <pre>[<br>  22,<br>  80,<br>  8800,<br>  9090,<br>  443,<br>  54422<br>]</pre> | no |
| <a name="input_yba_ssh_private_key_path"></a> [yba\_ssh\_private\_key\_path](#input\_yba\_ssh\_private\_key\_path) | Path to the private key for the SSH users | `string` | n/a | yes |
| <a name="input_yba_ssh_public_key_path"></a> [yba\_ssh\_public\_key\_path](#input\_yba\_ssh\_public\_key\_path) | Path to the public key for the SSH users | `string` | n/a | yes |
| <a name="input_yba_ssh_user"></a> [yba\_ssh\_user](#input\_yba\_ssh\_user) | Yugabyte Anywhere SSH Users use to provision the instance | `string` | n/a | yes |
| <a name="input_yba_version_number"></a> [yba\_version\_number](#input\_yba\_version\_number) | YBA version number including build number. (default: 2.18.3.0-b75) | `string` | `"2.18.3.0-b75"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_google_backup_creds"></a> [google\_backup\_creds](#output\_google\_backup\_creds) | google credentials for the backup |
| <a name="output_yba_firewall_tags"></a> [yba\_firewall\_tags](#output\_yba\_firewall\_tags) | Firewall tags needed for yba Cloud providers config |
| <a name="output_yba_project_name"></a> [yba\_project\_name](#output\_yba\_project\_name) | GCP Project ID |
| <a name="output_yba_public_ip"></a> [yba\_public\_ip](#output\_yba\_public\_ip) | n/a |
| <a name="output_yba_regions_subnets"></a> [yba\_regions\_subnets](#output\_yba\_regions\_subnets) | Map of region and subnet formated as region/subnet-name |
| <a name="output_yba_vpc_network_name"></a> [yba\_vpc\_network\_name](#output\_yba\_vpc\_network\_name) | Name of the VPC network name |
