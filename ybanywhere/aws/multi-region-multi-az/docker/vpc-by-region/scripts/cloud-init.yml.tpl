#cloud-config
package_update: true
package_upgrade: true
ssh_authorized_keys:
- ${public_key_node}

packages:
  - curl
  - wget
  - awscli
  - jq
  - python3

runcmd:
  - |
    mkdir /tmp/ssm && cd /tmp/ssm
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
    sudo dpkg -i amazon-ssm-agent.deb
    sudo systemctl enable amazon-ssm-agent
