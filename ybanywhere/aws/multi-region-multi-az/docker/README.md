# Description

This Terraform code will provision an AWS multi-region multi-zone deployment and install YB anywhere to one of them.


# AWS
* This is using a single AWS account 
* Each region will contain one VPC with both public and private subnet with NAT gateway.
* Each VPC will be peered with other VPC


# YB Anywhere

* Deployed using Replicated (docker)
* Deploy into one of the public subnet
* Only HTTP is supported 


# Run
Make sure you are connected to your AWS account (sso, access key, ...)

**This run will require 2 plan/apply in two times as it is not possible to do cross-region in one run with the module used for the peering.**


1. Variable file 
   Create ".tfvars" file containing the required variable (see example.tfvars)

2. Terraform initialization
 
```shell
terraform init
```

3. Create VPC in all region and deployed YBA

```shell
terraform plan -var-file=yourvars-file.tfvars -out vpc.tfplan  --target module.r1 --target module.r2  --target module.r3
terraform apply "vpc.tfplan"
```

4. Setup peering

```shell
terraform plan -var-file=yourvars-file.tfvars -out peering.tfplan  --target module.vpc-peering-r1-r2 --target module.vpc-peering-r1-r3  --target module.vpc-peering-r2-r3

terraform apply "peering.tfplan"
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_sources"></a> [allowed\_sources](#input\_allowed\_sources) | Source ips to restrict traffic, for example ["YOUR\_IP/32"] (Required) | `list(string)` | n/a | yes |
| <a name="input_aws_region_1"></a> [aws\_region\_1](#input\_aws\_region\_1) | First AWS Region | `string` | n/a | yes |
| <a name="input_aws_region_2"></a> [aws\_region\_2](#input\_aws\_region\_2) | Second AWS Region | `string` | n/a | yes |
| <a name="input_aws_region_3"></a> [aws\_region\_3](#input\_aws\_region\_3) | Third AWS Region | `string` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | List of tags to be applied to every resources (Required) | `map(any)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the YugabyteDB Anywhere node (default: c5.xlarge) | `string` | `"c5.xlarge"` | no |
| <a name="input_license_path"></a> [license\_path](#input\_license\_path) | Local path to the license ril file | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to be used for every created resources, Please use 3-4 char. (Required) | `string` | n/a | yes |
| <a name="input_ssh_keypair_name"></a> [ssh\_keypair\_name](#input\_ssh\_keypair\_name) | AWS key pair name (Required) | `string` | n/a | yes |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Volume size for YugabyteDB Anywhere node (default: 100) | `string` | `"100"` | no |
