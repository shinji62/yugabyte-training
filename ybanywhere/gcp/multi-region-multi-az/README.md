# Description

This Terraform code will:

* Provision an GCP multi-region multi-zone deployment
* Install YB anywhere to one of them.
* Create a bucket and setup as storage config in YBA
* Will set up a 3 nodes Universe across the 3 regions

# GCP
* This is using a single GCP account 

# YB Anywhere

* Deployed using terraform YBA provider
* Deploy into one of the public subnet
* Use HTTPS with generated certificate 
  
  
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

Please use the Terraform output to configure the GCP Cloud provider, please use "Service account of the instance" you don't need any additional service account.

# Replicated password
To output the password of replicated please use the following command

```
shell
terraform output -json replicated_password
```

# Cleaning
Please delete from YBA interface
1. Universes
2. Cloud Provider Config

```shell
terraform destroy -var-file=yourvars-file.tfvars 
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.43.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.43.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp-vpc"></a> [gcp-vpc](#module\_gcp-vpc) | terraform-google-modules/network/google | ~> 5.2 |

## Resources

| Name | Type |
|------|------|
| [google_compute_disk.yba_boot_disk](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/compute_disk) | resource |
| [google_compute_firewall.yb_anywhere_db_node](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.yb_anywhere_inst](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/compute_firewall) | resource |
| [google_compute_instance.yugabyte_anywhere_instances](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/compute_instance) | resource |
| [google_project_iam_member.project](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/project_iam_member) | resource |
| [google_service_account.sa_yba_instance](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/service_account) | resource |
| [google_storage_bucket.license_bucket](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.license_bucket](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_object.picture](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/resources/storage_bucket_object) | resource |
| [null_resource.delay](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_id.gcs_bucket_random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.replicated_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_compute_image.ubuntu2004](https://registry.terraform.io/providers/hashicorp/google/4.43.1/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sources"></a> [allowed\_sources](#input\_allowed\_sources) | Source ips to restrict traffic, for example ["YOUR\_IP/32"] (Required) | `list(string)` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | List of tags to be applied to every resources (Required) | `map(any)` | n/a | yes |
| <a name="input_gcp_region_1"></a> [gcp\_region\_1](#input\_gcp\_region\_1) | GCP region (default: asia-northeast1) | `string` | `"asia-northeast1"` | no |
| <a name="input_gcp_region_2"></a> [gcp\_region\_2](#input\_gcp\_region\_2) | GCP region (default: asia-northeast2) | `string` | `"asia-northeast2"` | no |
| <a name="input_gcp_region_3"></a> [gcp\_region\_3](#input\_gcp\_region\_3) | GCP region (default: asia-northeast3) | `string` | `"asia-northeast3"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the YugabyteDB Anywhere node (default: n1-standard-4) | `string` | `"n1-standard-4"` | no |
| <a name="input_license_path"></a> [license\_path](#input\_license\_path) | Local path to the license ril file | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id | `string` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Local path to you public key to connect to YBA instance | `string` | n/a | yes |
| <a name="input_replicated_password"></a> [replicated\_password](#input\_replicated\_password) | Password for replicated daemon, if not specified will be generated. | `string` | `null` | no |
| <a name="input_replicated_seq_number"></a> [replicated\_seq\_number](#input\_replicated\_seq\_number) | Specific replicated version to pin to. | `number` | `null` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to be used for every created resources, Please use 3-4 char. (Required) | `string` | n/a | yes |
| <a name="input_ssh_keypair_name"></a> [ssh\_keypair\_name](#input\_ssh\_keypair\_name) | AWS key pair name (Required) | `string` | n/a | yes |
| <a name="input_vm_image"></a> [vm\_image](#input\_vm\_image) | n/a | `string` | `"ubuntu-2004-focal-v20221018"` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size for YugabyteDB Anywhere node (default: 100) | `string` | `"100"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_replicated_password"></a> [replicated\_password](#output\_replicated\_password) | Replicated password to get it please use terraform ouput command |
| <a name="output_yba_firewall_tags"></a> [yba\_firewall\_tags](#output\_yba\_firewall\_tags) | Firewall tags needed for yba Cloud providers config |
| <a name="output_yba_project_name"></a> [yba\_project\_name](#output\_yba\_project\_name) | GCP Project ID |
| <a name="output_yba_public_ip"></a> [yba\_public\_ip](#output\_yba\_public\_ip) | n/a |
| <a name="output_yba_regions_subnets"></a> [yba\_regions\_subnets](#output\_yba\_regions\_subnets) | Map of region and subnet formated as region/subnet-name |
| <a name="output_yba_vpc_network_name"></a> [yba\_vpc\_network\_name](#output\_yba\_vpc\_network\_name) | Name of the VPC network name |
