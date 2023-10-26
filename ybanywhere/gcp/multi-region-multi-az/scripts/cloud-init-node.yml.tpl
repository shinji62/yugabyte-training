#cloud-config
package_update: true
package_upgrade: true

ssh_deletekeys: false
ssh_authorized_keys:
- ${public_key_node}

packages:
  - curl
  - wget
  - jq
  - python

bootcmd:
- while [ ! -b $(readlink -f /dev/disk/by-id/google-node-m-disk) ]; do echo "waiting for device /dev/disk/by-id/google-node-m-disk"; sleep 5 ; done
- blkid $(readlink -f /dev/disk/by-id/google-node-m-disk) || mkfs -t xfs $(readlink -f /dev/disk/by-id/google-node-m-disk)
- mkdir -p /mnt/data

mounts:
- [ "/dev/disk/by-id/google-node-m-disk", "/mnt/data", "xfs", "defaults,nofail,noatime" ]

runcmd:
  - | 
    # Install GCloud CLI
    snap install google-cloud-cli --classic

