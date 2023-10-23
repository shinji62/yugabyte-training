# Description

This Terraform code will:

* Provision an AWS single region VNET
* Install YB anywhere
* Will set up a 3 nodes Universe
* 

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
3. Deploy

```shell
terraform plan -var-file=yourvars-file.tfvars -out az-on-regiob.tfplan
terraform apply az-one-region.tfplan
```


# YBA anywhere 

!! Please be aware that Azure provisioning may take a long time, so please wait if you YBA do not show up !! 

You can now access to YBA by using the `yugabyte_anywhere_public_ip` output by your terraform.

Please use the Terraform output to configure the AWS Cloud provider, please use "Service account of the instance" you don't need any additional service account.


# Cleaning

```shell
terraform destroy -var-file=yourvars-file.tfvars 
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.32.0 |
| <a name="requirement_checkmate"></a> [checkmate](#requirement\_checkmate) | 1.5.0 |
| <a name="requirement_yba"></a> [yba](#requirement\_yba) | 0.1.0-dev |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.43.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.32.0 |
| <a name="provider_checkmate"></a> [checkmate](#provider\_checkmate) | 1.5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_yba.authenticated"></a> [yba.authenticated](#provider\_yba.authenticated) | 0.1.0-dev |
| <a name="provider_yba.unauthenticated"></a> [yba.unauthenticated](#provider\_yba.unauthenticated) | 0.1.0-dev |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.yba-app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azurerm_linux_virtual_machine.yb_anywhere_node_on_prem](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.yba_inst](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_managed_disk.yba-data-disk-node](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.yba_inst_nic](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface.yba_node_inst_nic](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.yba_nic_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.yba_node_nic_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.yba_sg](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.icmp_rule](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.yba_rules](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.yba_node_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.yba_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.yba_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/resource_group) | resource |
| [azurerm_storage_account.yba_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/storage_account) | resource |
| [azurerm_storage_blob.license](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.yba_license_blob_cont](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/storage_container) | resource |
| [azurerm_subnet.yba_sub_internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/subnet) | resource |
| [azurerm_virtual_machine_data_disk_attachment.yba-data-disk-node-attch](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_network.yba_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/resources/virtual_network) | resource |
| [checkmate_http_health.example](https://registry.terraform.io/providers/tetratelabs/checkmate/1.5.0/docs/resources/http_health) | resource |
| [random_string.storage_account_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [yba_cloud_provider.gcp](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/resources/cloud_provider) | resource |
| [yba_customer_resource.customer](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/resources/customer_resource) | resource |
| [yba_installer.install](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/resources/installer) | resource |
| [yba_universe.gcprf3](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/resources/universe) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_storage_account_blob_container_sas.yba_license_bucket_sas](https://registry.terraform.io/providers/hashicorp/azurerm/3.32.0/docs/data-sources/storage_account_blob_container_sas) | data source |
| [yba_provider_key.gcp_key](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/data-sources/provider_key) | data source |
| [yba_release_version.release_version](https://registry.terraform.io/providers/yugabyte/yba/0.1.0-dev/docs/data-sources/release_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sources"></a> [allowed\_sources](#input\_allowed\_sources) | Source ips to restrict traffic, for example ["YOUR\_IP/32"] (Required) | `list(string)` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | Azure Ad | `string` | `null` | no |
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location (default: Japan East) | `string` | `"Japan East"` | no |
| <a name="input_azure_locations_zone"></a> [azure\_locations\_zone](#input\_azure\_locations\_zone) | Azure Avaibility zone (default: ["1", "2", "3"] ) | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |
| <a name="input_create_yba_instances"></a> [create\_yba\_instances](#input\_create\_yba\_instances) | When true, will deploy the yba anywhere on this VPC with public IP. | `bool` | `false` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | List of tags to be applied to every resources (Required) | `map(any)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the YugabyteDB Anywhere node (default: Standard\_D4s\_v3) | `string` | `"Standard_D4s_v3"` | no |
| <a name="input_license_path"></a> [license\_path](#input\_license\_path) | Local path to the license ril file | `string` | n/a | yes |
| <a name="input_node_data_disk_size"></a> [node\_data\_disk\_size](#input\_node\_data\_disk\_size) | Volume size for YugabyteDB  node (default: 100) | `string` | `"100"` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Instance type for the YugabyteDB node (default: Standard\_D4s\_v3) | `string` | `"Standard_D4s_v3"` | no |
| <a name="input_node_on_prem_disk_size"></a> [node\_on\_prem\_disk\_size](#input\_node\_on\_prem\_disk\_size) | Volume size for YugabyteDB node (default: 100) | `string` | `"100"` | no |
| <a name="input_node_on_prem_public_key_path"></a> [node\_on\_prem\_public\_key\_path](#input\_node\_on\_prem\_public\_key\_path) | Local path to you public key to connect to YB Node instance (Default: same as public\_key\_path) | `string` | `null` | no |
| <a name="input_node_on_prem_test"></a> [node\_on\_prem\_test](#input\_node\_on\_prem\_test) | Will create X nodes to test on\_prem accross az | `number` | `0` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Local path to you public key to connect to YBA instance | `string` | n/a | yes |
| <a name="input_replicated_password"></a> [replicated\_password](#input\_replicated\_password) | Password for replicated daemon, if not specified will be generated. | `string` | `null` | no |
| <a name="input_replicated_seq_number"></a> [replicated\_seq\_number](#input\_replicated\_seq\_number) | Specific replicated version to pin to. | `number` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Azure Resource group, if not specified will create a new one | `string` | `null` | no |
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
| <a name="output_azure_location"></a> [azure\_location](#output\_azure\_location) | Azure Location |
| <a name="output_node_on_prem"></a> [node\_on\_prem](#output\_node\_on\_prem) | Node for on prem cloud provider testing |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Azure resource group name |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the security group |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | Azure subnet |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Azure subscription ID |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | Azure Tenant ID |
| <a name="output_vnet_net"></a> [vnet\_net](#output\_vnet\_net) | Azure Virtual Network name |
| <a name="output_yugabyte_anywhere_public_ip"></a> [yugabyte\_anywhere\_public\_ip](#output\_yugabyte\_anywhere\_public\_ip) | Public IP of your Yugabyte anywhere |
