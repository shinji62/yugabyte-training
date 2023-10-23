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

bootcmd:
- while [ ! -b $(readlink -f /dev/nvme1n1) ]; do echo "waiting for device /dev/nvme1n1"; sleep 5 ; done
- blkid $(readlink -f /dev/nvme1n1) || mkfs -t xfs $(readlink -f /dev/nvme1n1)
- mkdir -p /mnt/data

mounts:
- [ "/dev/nvme1n1", "/mnt/data", "xfs", "defaults,nofail,noatime" ]

runcmd:
  - |
    mkdir /tmp/ssm && cd /tmp/ssm
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
    sudo dpkg -i amazon-ssm-agent.deb
    sudo systemctl enable amazon-ssm-agent

