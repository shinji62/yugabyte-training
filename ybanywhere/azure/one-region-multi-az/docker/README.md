# Description

This deployment will create a regional Virtual network and install YB anywhere.


# Azure
* Todo


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
terraform plan -var-file=yourvars-file.tfvars -out az-on-regiob.tfplan
terraform apply az-one-region.tfplan
```


# YBA anywhere 

!! Please be aware that Azure provisioning may take a long time, so please wait if you YBA do not show up !! 

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
