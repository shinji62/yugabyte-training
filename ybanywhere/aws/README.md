# Ybanywhere

This folder dedployment everything related to [Yugabyte Anywhere](https://www.yugabyte.com/anywhere/) on AWS


# Important notes
* Check the Readme of every deployment
* One terraform run, it will take around 2-3 min for YBA to come online
* **Please do not use wide listed CIDR like `0.0.0.0/0` for allowed_sources**

# Prerequisites 

* AWS account with admin permission
* AWS key pair
* Terraform ~0.13

# Folders structures

* [`one-region-multi-az`](./one-region-mutli-az/docker/README.md) Multi-AZ deployment


