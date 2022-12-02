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
* Terraform ~0.13


# Yugabyte Anywhere node
You can deploy one instances of YBA on every Cloud if needed, just set the variable `(aws|gcp|azure)_create_yba_instances` to `true`.

# On Prem node 
You can deploy empty VM by setting those variables `*node_on_prem_test`
For multi-cloud Universe you need to use on-Prem Cloud provider, most of the needed information will be displayed in the output.

Please use `ubuntu` for the ssh user, then to configure the node please use private ips.


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

**Please delete from YBA interface**
1. Universes
2. Cloud Provider Config

```shell
terraform destroy -var-file=yourvars-file.tfvars 
```



## Requirements

| Name                                                                | Version |
| ------------------------------------------------------------------- | ------- |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)             | ~> 4.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.33.0  |
| <a name="requirement_google"></a> [google](#requirement\_google)    | 4.43.1  |


## Modules

| Name                                                                                 | Source  | Version |
| ------------------------------------------------------------------------------------ | ------- | ------- |
| <a name="module_aws-vpc-vpn-gw"></a> [aws-vpc-vpn-gw](#module\_aws-vpc-vpn-gw)       | ./aws   | n/a     |
| <a name="module_azure-vpc-vpn-gw"></a> [azure-vpc-vpn-gw](#module\_azure-vpc-vpn-gw) | ./azure | n/a     |
| <a name="module_gcp-vpc-vpn-gw"></a> [gcp-vpc-vpn-gw](#module\_gcp-vpc-vpn-gw)       | ./gcp   | n/a     |
| <a name="module_vpn"></a> [vpn](#module\_vpn)                                        | ./vpn   | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                                                                             | Description                                                                    | Type           | Default             | Required |
| -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | -------------- | ------------------- | :------: |
| <a name="input_allowed_sources"></a> [allowed\_sources](#input\_allowed\_sources)                                                | Source ips to restrict traffic, for example ["YOUR\_IP/32"] (Required)         | `list(string)` | n/a                 |   yes    |
| <a name="input_aws_create_yba_instances"></a> [aws\_create\_yba\_instances](#input\_aws\_create\_yba\_instances)                 | When true, will deploy the yba anywhere on this VPC with public IP.            | `bool`         | `false`             |    no    |
| <a name="input_aws_node_on_prem_test"></a> [aws\_node\_on\_prem\_test](#input\_aws\_node\_on\_prem\_test)                        | Will create X nodes to test on\_prem accross az for AWS                        | `number`       | `0`                 |    no    |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region)                                                               | AWS region, 3 AZ will be created from the region (default: ap-northeast-1)     | `string`       | `"ap-northeast-1"`  |    no    |
| <a name="input_aws_ssh_keypair_name"></a> [aws\_ssh\_keypair\_name](#input\_aws\_ssh\_keypair\_name)                             | AWS key pair name (Required)                                                   | `string`       | n/a                 |   yes    |
| <a name="input_azure_create_yba_instances"></a> [azure\_create\_yba\_instances](#input\_azure\_create\_yba\_instances)           | When true, will deploy the yba anywhere on this VPC with public IP.            | `bool`         | `false`             |    no    |
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location)                                                   | Azure location (default: Japan East)                                           | `string`       | `"Japan East"`      |    no    |
| <a name="input_azure_node_on_prem_test"></a> [azure\_node\_on\_prem\_test](#input\_azure\_node\_on\_prem\_test)                  | Will create X nodes to test on\_prem accross az for AWS                        | `number`       | `0`                 |    no    |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group)                               | Azure Resource group, if not specified will create a new one                   | `string`       | `null`              |    no    |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags)                                                         | List of tags to be applied to every resources (Required)                       | `map(any)`     | n/a                 |   yes    |
| <a name="input_gcp_create_yba_instances"></a> [gcp\_create\_yba\_instances](#input\_gcp\_create\_yba\_instances)                 | When true, will deploy the yba anywhere on this VPC with public IP.            | `bool`         | `false`             |    no    |
| <a name="input_gcp_node_on_prem_test"></a> [gcp\_node\_on\_prem\_test](#input\_gcp\_node\_on\_prem\_test)                        | Will create X nodes to test on\_prem accross az for GCP                        | `number`       | `0`                 |    no    |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region)                                                               | GCP region (default: asia-northeast1)                                          | `string`       | `"asia-northeast1"` |    no    |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type)                                                      | Instance type for the YugabyteDB Anywhere node (default: c5.xlarge)            | `string`       | `"c5.xlarge"`       |    no    |
| <a name="input_license_path"></a> [license\_path](#input\_license\_path)                                                         | Local path to the license ril file                                             | `string`       | n/a                 |   yes    |
| <a name="input_node_on_prem_public_key_path"></a> [node\_on\_prem\_public\_key\_path](#input\_node\_on\_prem\_public\_key\_path) | Local path to you public key to connect to YB Node instance (Default: empty)   | `string`       | `null`              |    no    |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id)                                                               | GCP project id                                                                 | `string`       | n/a                 |   yes    |
| <a name="input_replicated_password"></a> [replicated\_password](#input\_replicated\_password)                                    | Password for replicated daemon, if not specified will be generated.            | `string`       | `null`              |    no    |
| <a name="input_replicated_seq_number"></a> [replicated\_seq\_number](#input\_replicated\_seq\_number)                            | Specific replicated version to pin to.                                         | `number`       | `null`              |    no    |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix)                                                | Prefix to be used for every created resources, Please use 3-4 char. (Required) | `string`       | n/a                 |   yes    |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)                                                | Azure Subscription id                                                          | `string`       | n/a                 |   yes    |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id)                                                                  | Azure tenant id where you want to deploy                                       | `string`       | n/a                 |   yes    |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size)                                                            | Volume size for YugabyteDB Anywhere node (default: 100)                        | `string`       | `"100"`             |    no    |

## Outputs

| Name                                                                                             | Description                             |
| ------------------------------------------------------------------------------------------------ | --------------------------------------- |
| <a name="output_aws_node_on_prem"></a> [aws\_node\_on\_prem](#output\_aws\_node\_on\_prem)       | n/a                                     |
| <a name="output_aws_regions_yba"></a> [aws\_regions\_yba](#output\_aws\_regions\_yba)            | n/a                                     |
| <a name="output_azure_node_on_prem"></a> [azure\_node\_on\_prem](#output\_azure\_node\_on\_prem) | n/a                                     |
| <a name="output_gcp_node_on_prem"></a> [gcp\_node\_on\_prem](#output\_gcp\_node\_on\_prem)       | Node for on prem cloud provider testing |
