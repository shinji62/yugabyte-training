# Description

This Terraform code will provision an AWS single region multi-zone deployment and install YB anywhere to one instances.

# AWS
* This is using a single AWS account 
* Region contain one VPC with both public and private subnet with NAT gateway.


# YB Anywhere

* Deployed using terraform YBA provider
* Deploy into one of the public subnet
* Use HTTPS with generated certificate 


# Run
Make sure you are connected to your AWS account (sso, access key, ...)


1. Variable file 
   Create ".tfvars" file containing the required variable (see example.tfvars)

2. Terraform initialization
 
```shell
terraform init
```

3. Create VPC in all region and deployed YBA

```shell
terraform plan -var-file=yourvars-file.tfvars -out vpc.tfplan 
terraform apply "vpc.tfplan"
```

# YBA anywhere 
You can now access to YBA by using the `yugabyte_anywhere_public_ip` output by your terraform.

Please use the Terraform output to configure the AWS Cloud provider, please use "Service account of the instance" you don't need any additional service account.

# Cleaning

```shell
terraform destroy -var-file=yourvars-file.tfvars 
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_checkmate"></a> [checkmate](#requirement\_checkmate) | 1.5.0 |
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_checkmate"></a> [checkmate](#provider\_checkmate) | 1.5.0 |
| <a name="provider_yba.authenticated"></a> [yba.authenticated](#provider\_yba.authenticated) | 0.1.8 |
| <a name="provider_yba.unauthenticated"></a> [yba.unauthenticated](#provider\_yba.unauthenticated) | 0.1.8 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_r1"></a> [r1](#module\_r1) | ../multi-region-multi-az/docker/vpc-by-region | n/a |

## Resources

| Name | Type |
|------|------|
| [checkmate_http_health.example](https://registry.terraform.io/providers/tetratelabs/checkmate/1.5.0/docs/resources/http_health) | resource |
| [yba_cloud_provider.aws](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/resources/cloud_provider) | resource |
| [yba_customer_resource.customer](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/resources/customer_resource) | resource |
| [yba_installer.install](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/resources/installer) | resource |
| [yba_storage_config_resource.storage_config](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/resources/storage_config_resource) | resource |
| [yba_universe.awsrf3](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/resources/universe) | resource |
| [yba_provider_key.aws_key](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/data-sources/provider_key) | data source |
| [yba_release_version.release_version](https://registry.terraform.io/providers/yugabyte/yba/0.1.8/docs/data-sources/release_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sources"></a> [allowed\_sources](#input\_allowed\_sources) | Source ips to restrict traffic, for example ["YOUR\_IP/32"] (Required) | `list(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region (Default: ap-northeast-1) | `string` | `"ap-northeast-1"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | List of tags to be applied to every resources (Required) | `map(any)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the YugabyteDB Anywhere node (default: c5.xlarge) | `string` | `"c5.xlarge"` | no |
| <a name="input_license_path"></a> [license\_path](#input\_license\_path) | Local path to the license ril file | `string` | n/a | yes |
| <a name="input_node_on_prem_public_key_path"></a> [node\_on\_prem\_public\_key\_path](#input\_node\_on\_prem\_public\_key\_path) | Local path to you public key to connect to YB Node instance (Default: empty) | `string` | `null` | no |
| <a name="input_node_on_prem_test"></a> [node\_on\_prem\_test](#input\_node\_on\_prem\_test) | Will create X nodes to test on\_prem accross az (Default: 0) | `number` | `0` | no |
| <a name="input_private_subnets_tag"></a> [private\_subnets\_tag](#input\_private\_subnets\_tag) | Private subnet tags. Could be useful for kubernetes ALB controller | `map(any)` | `{}` | no |
| <a name="input_public_subnets_tag"></a> [public\_subnets\_tag](#input\_public\_subnets\_tag) | Public subnet tags. Could be useful for kubernetes ALB controller | `map(any)` | `{}` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to be used for every created resources, Please use 3-4 char. (Required) | `string` | n/a | yes |
| <a name="input_ssh_keypair_name"></a> [ssh\_keypair\_name](#input\_ssh\_keypair\_name) | AWS key pair name (Required) | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size for YugabyteDB Anywhere node (default: 100) | `string` | `"100"` | no |
| <a name="input_yba_application_settings_file_path"></a> [yba\_application\_settings\_file\_path](#input\_yba\_application\_settings\_file\_path) | Path the YBA installer application settings file | `string` | n/a | yes |
| <a name="input_yba_customer_code"></a> [yba\_customer\_code](#input\_yba\_customer\_code) | Label for the user. (default: admin). | `string` | `"admin"` | no |
| <a name="input_yba_customer_email"></a> [yba\_customer\_email](#input\_yba\_customer\_email) | Email for the user, which is used for login on the YugabyteDB Anywhere portal. | `string` | n/a | yes |
| <a name="input_yba_customer_name"></a> [yba\_customer\_name](#input\_yba\_customer\_name) | Name of the user. (default: admin) | `string` | n/a | yes |
| <a name="input_yba_license_file_path"></a> [yba\_license\_file\_path](#input\_yba\_license\_file\_path) | Path to the YBA license file | `string` | n/a | yes |
| <a name="input_yba_ssh_private_key_path"></a> [yba\_ssh\_private\_key\_path](#input\_yba\_ssh\_private\_key\_path) | Path to the private key for the SSH users | `string` | n/a | yes |
| <a name="input_yba_ssh_user"></a> [yba\_ssh\_user](#input\_yba\_ssh\_user) | Yugabyte Anywhere SSH Users use to provision the instance | `string` | n/a | yes |
| <a name="input_yba_version_number"></a> [yba\_version\_number](#input\_yba\_version\_number) | YBA version number including build number. (default: 2.18.3.0-b75) | `string` | `"2.18.3.0-b75"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_on_prem"></a> [node\_on\_prem](#output\_node\_on\_prem) | n/a |
| <a name="output_region_output"></a> [region\_output](#output\_region\_output) | Region |