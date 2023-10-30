# Description

This Terraform code will set up a multi-cloud environment between AWS GCP and Azure.

Both GCP and Azure will be connected to AWS using HA Site-to-Site VPN and BGP for announcing their route.

Other resource VCP, VNET will be created in respected Cloud.


Thanks to Azure can take up to 40 min.

# Important notes
* One terraform run, it will take around 2-3 min for YBA to come online
* **Please do not use wide listed CIDR like `0.0.0.0/0` for allowed_sources**
  
# Prerequisites 

* GCP account with owner permission on the project
* A local Key pair


# YB Anywhere

* Deployed using terraform YBA provider
* Deploy into one of the public subnet
* Use HTTPS with generated certificate


# On Prem node 
You can deploy empty VM by setting those variables `node_on_prem_test`


For example, this will create 3 nodes in AWS and GCP and Azure
```hcl
node_on_prem_public_key_path = "pat/to/your/public/key"
aws_node_on_prem_test        = 3
gcp_node_on_prem_test        = 3
azure_node_on_prem_test      = 3
```

# Run
Make sure you are connected to your AWS, Azure, and GCP account (sso, access key, ...)

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


# Troubleshooting

During the deployment some issues can occur, especially related to Azure

1. Quota Issues
Please fix it using the link provided with the error messages (Azure) or by increasing quota on the console (GCP, AWS)
Re-run `terraform plan` command and then `terraform apply` command with the correct arguments.

For example 
```
error: expected ip_address to contain a valid IPv4 address, got: 
│ 
│   with module.vpn.aws_customer_gateway.azure_1,
│   on vpn/aws.tf line 78, in resource "aws_customer_gateway" "azure_1":
│   78:   ip_address = data.azurerm_public_ip.azure_1.ip_address
│ 
╵
╷
│ Error: expected ip_address to contain a valid IPv4 address, got: 
│ 
│   with module.vpn.aws_customer_gateway.azure_2,
│   on vpn/aws.tf line 95, in resource "aws_customer_gateway" "azure_2":
│   95:   ip_address = data.azurerm_public_ip.azure_2.ip_address
```

2. Diverse resources errors
Most of the time is related to Azure weirdness or timing out, so in this case just re-run `terraform plan` command and then `terraform apply` command with the correct arguments.



# Cleaning

```shell
terraform destroy -var-file=yourvars-file.tfvars 
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.7.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.33.0 |
| <a name="requirement_checkmate"></a> [checkmate](#requirement\_checkmate) | 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.43.1 |
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_checkmate"></a> [checkmate](#provider\_checkmate) | 1.5.0 |
| <a name="provider_yba.authenticated"></a> [yba.authenticated](#provider\_yba.authenticated) | 0.1.9 |
| <a name="provider_yba.unauthenticated"></a> [yba.unauthenticated](#provider\_yba.unauthenticated) | 0.1.9 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-vpc-vpn-gw"></a> [aws-vpc-vpn-gw](#module\_aws-vpc-vpn-gw) | ./aws | n/a |
| <a name="module_azure-vpc-vpn-gw"></a> [azure-vpc-vpn-gw](#module\_azure-vpc-vpn-gw) | ./azure | n/a |
| <a name="module_gcp-vpc-vpn-gw"></a> [gcp-vpc-vpn-gw](#module\_gcp-vpc-vpn-gw) | ./gcp | n/a |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ./vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [checkmate_http_health.example](https://registry.terraform.io/providers/tetratelabs/checkmate/1.5.0/docs/resources/http_health) | resource |
| [yba_customer_resource.customer](https://registry.terraform.io/providers/yugabyte/yba/0.1.9/docs/resources/customer_resource) | resource |
| [yba_installer.install](https://registry.terraform.io/providers/yugabyte/yba/0.1.9/docs/resources/installer) | resource |
| [yba_onprem_provider.onprem](https://registry.terraform.io/providers/yugabyte/yba/0.1.9/docs/resources/onprem_provider) | resource |
| [yba_storage_config_resource.storage_config](https://registry.terraform.io/providers/yugabyte/yba/0.1.9/docs/resources/storage_config_resource) | resource |
| [yba_universe.onprem_universe](https://registry.terraform.io/providers/yugabyte/yba/0.1.9/docs/resources/universe) | resource |
| [yba_provider_key.onprem_key](https://registry.terraform.io/providers/yugabyte/yba/0.1.9/docs/data-sources/provider_key) | data source |
| [yba_release_version.release_version](https://registry.terraform.io/providers/yugabyte/yba/0.1.9/docs/data-sources/release_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sources"></a> [allowed\_sources](#input\_allowed\_sources) | Source ips to restrict traffic, for example ["YOUR\_IP/32"] (Required) | `list(string)` | n/a | yes |
| <a name="input_aws_create_yba_instances"></a> [aws\_create\_yba\_instances](#input\_aws\_create\_yba\_instances) | When true, will deploy the yba anywhere on this VPC with public IP. | `bool` | `false` | no |
| <a name="input_aws_node_on_prem_test"></a> [aws\_node\_on\_prem\_test](#input\_aws\_node\_on\_prem\_test) | Will create X nodes to test on\_prem accross az for AWS | `number` | `0` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region, 3 AZ will be created from the region (default: ap-northeast-1) | `string` | `"ap-northeast-1"` | no |
| <a name="input_aws_ssh_keypair_name"></a> [aws\_ssh\_keypair\_name](#input\_aws\_ssh\_keypair\_name) | AWS key pair name (Required) | `string` | n/a | yes |
| <a name="input_azure_create_yba_instances"></a> [azure\_create\_yba\_instances](#input\_azure\_create\_yba\_instances) | When true, will deploy the yba anywhere on this VPC with public IP. | `bool` | `false` | no |
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location (default: Japan East) | `string` | `"Japan East"` | no |
| <a name="input_azure_node_on_prem_test"></a> [azure\_node\_on\_prem\_test](#input\_azure\_node\_on\_prem\_test) | Will create X nodes to test on\_prem accross az for AWS | `number` | `0` | no |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group) | Azure Resource group, if not specified will create a new one | `string` | `null` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | List of tags to be applied to every resources (Required) | `map(any)` | n/a | yes |
| <a name="input_gcp_create_yba_instances"></a> [gcp\_create\_yba\_instances](#input\_gcp\_create\_yba\_instances) | When true, will deploy the yba anywhere on this VPC with public IP. | `bool` | `false` | no |
| <a name="input_gcp_node_on_prem_test"></a> [gcp\_node\_on\_prem\_test](#input\_gcp\_node\_on\_prem\_test) | Will create X nodes to test on\_prem accross az for GCP | `number` | `0` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP region (default: asia-northeast1) | `string` | `"asia-northeast1"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the YugabyteDB Anywhere node (default: c5.xlarge) | `string` | `"c5.xlarge"` | no |
| <a name="input_node_on_prem_private_key_path"></a> [node\_on\_prem\_private\_key\_path](#input\_node\_on\_prem\_private\_key\_path) | Local path to you private key to connect to YB Node instance (Default: empty) | `string` | `null` | no |
| <a name="input_node_on_prem_public_key_path"></a> [node\_on\_prem\_public\_key\_path](#input\_node\_on\_prem\_public\_key\_path) | Local path to you public key to connect to YB Node instance (Default: empty) | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project id | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to be used for every created resources, Please use 3-4 char. (Required) | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription id | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant id where you want to deploy | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size for YugabyteDB Anywhere node (default: 100) | `string` | `"100"` | no |
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
| <a name="output_AWS"></a> [AWS](#output\_AWS) | n/a |
| <a name="output_AZURE"></a> [AZURE](#output\_AZURE) | n/a |
| <a name="output_gcp_node_on_prem"></a> [gcp\_node\_on\_prem](#output\_gcp\_node\_on\_prem) | Node for on prem cloud provider testing |
