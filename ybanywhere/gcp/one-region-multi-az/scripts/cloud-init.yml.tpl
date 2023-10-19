#cloud-config
package_update: true
package_upgrade: true

ssh_deletekeys: false
ssh_authorized_keys:
- ${public_key}

packages:
  - curl
  - wget
  - jq
  - python

runcmd:
  - | 
    # Install GCloud CLI
    snap install google-cloud-cli --classic