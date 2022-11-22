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

write_files:
  - content: |
      ${replicated_conf}
    encoding: b64
    owner: root:root
    path: /etc/replicated.conf
    permissions: '0750'
  - content: |
      ${application_settings}
    encoding: b64
    owner: root:root
    path: /tmp/settings.conf
    permissions: '0750'


runcmd:
  - | 
    # Install GCloud CLI
    snap install google-cloud-cli --classic
  - |
     # Get public IP
     export PUBLIC_IP=$(curl curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
     cat /tmp/settings.conf | jq ".hostname.value=env.PUBLIC_IP" | sudo tee /tmp/settings.conf
  - |
     # Change password for replicated
     cat /etc/replicated.conf | jq '.DaemonAuthenticationPassword="${replicated_password}"' | sudo tee /etc/replicated.conf > /dev/null
%{ if replicated_seq_number != null ~}
     cat /etc/replicated.conf | jq '.ReleaseSequence=${replicated_seq_number}' | sudo tee /etc/replicated.conf  > /dev/null
%{ endif ~}
  - |
    # Get License from s3
    gsutil cp gs://${license_bucket}/license.rli /tmp/license.rli
    sudo chown root:root /tmp/license.rli
    sudo chmod 0750 /tmp/license.rli
    # Install replicated 
    curl -sSL https://get.replicated.com/docker | sudo bash
    # Check if everything is install as required
    sudo docker ps --format "{{.ID}}: {{.Image}}: {{.Command}}: {{.Ports}}"
