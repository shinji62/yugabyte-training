# Description

This deployment will create a multi-az VPC in one region and install YB anywhere to one of them.


# AWS
* VPC will contain public and private subnet with NAT gateway.


# YB Anywhere

* Deployed using Replicated (docker)
* Deploy into one of the public subnet
* Only HTTP is supported 


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
terraform plan -var-file=yourvars-file.tfvars -out on-region.tfplan
terraform apply on-region.tfplan
```


# YBA anywhere 
You can now access to YBA by using the `yugabyte_anywhere_public_ip` output by your terraform.

Please use the Terraform output to configure the AWS Cloud provider, please use "Service account of the instance" you don't need any additional service account.

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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.39.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 3.18.1 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sources"></a> [allowed\_sources](#input\_allowed\_sources) | Source ips to restrict traffic, for example ["YOUR\_IP/32"] (Required) | `list(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region, 3 AZ will be created from the region (default: ap-northeast-1) | `string` | `"ap-northeast-1"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | List of tags to be applied to every resources (Required) | `map(any)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the YugabyteDB Anywhere node (default: c5.xlarge) | `string` | `"c5.xlarge"` | no |
| <a name="input_license_path"></a> [license\_path](#input\_license\_path) | Local path to the license ril file | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to be used for every created resources, Please use 3-4 char. (Required) | `string` | n/a | yes |
| <a name="input_ssh_keypair_name"></a> [ssh\_keypair\_name](#input\_ssh\_keypair\_name) | AWS key pair name (Required) | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size for YugabyteDB Anywhere node (default: 100) | `string` | `"100"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_yugabyte_anywhere_public_ip"></a> [yugabyte\_anywhere\_public\_ip](#output\_yugabyte\_anywhere\_public\_ip) | Public IP of your Yugabyte anywhere |
| <a name="output_yugabyte_anywhere_security_group_id"></a> [yugabyte\_anywhere\_security\_group\_id](#output\_yugabyte\_anywhere\_security\_group\_id) | Id of the Security Group where Yugabyte Anywhere is installed, could be use the configure the provider |
| <a name="output_yugabyte_anywhere_subnets_az_mapping"></a> [yugabyte\_anywhere\_subnets\_az\_mapping](#output\_yugabyte\_anywhere\_subnets\_az\_mapping) | Mapping of subnet to AZ, could be use the configure the provider |
| <a name="output_yugabyte_anywhere_vpc_id"></a> [yugabyte\_anywhere\_vpc\_id](#output\_yugabyte\_anywhere\_vpc\_id) | Id of the VPC where Yugabyte Anywhere is installed, could be use the configure the provider |