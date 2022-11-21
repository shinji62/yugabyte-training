# Yb Anywhere

This folder deployment everything related to [Yugabyte Anywhere](https://www.yugabyte.com/anywhere/) on GCP


# Important notes
* One terraform run, it will take around 2-3 min for YBA to come online
* **Please do not use wide listed CIDR like `0.0.0.0/0` for allowed_sources**

# Prerequisites 

* GCP account with owner permission on the project
* A local Key pair
* Terraform ~0.13

# Folders structures

* [`one-region-multi-az`](./one-region-mutli-az/docker/README.md) One region deployment
* [`multi-region-multi-az`](./one-region-mutli-az/docker/README.md) Multi region deployment
