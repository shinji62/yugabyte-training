#cloud-config
package_update: true
package_upgrade: true

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
     # Install Azure CLI
     curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  - |
     # Get public IP
     export PUBLIC_IP=$(curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text")
     cat /tmp/settings.conf | jq ".hostname.value=env.PUBLIC_IP" | sudo tee /tmp/settings.conf
  - |
     # Change password for replicated
     cat /etc/replicated.conf | jq '.DaemonAuthenticationPassword="${replicated_password}"' | sudo tee /etc/replicated.conf
  - |
    # Get License from s3
    curl "${license_download}" -o /tmp/license.rli
    sudo chown root:root /tmp/license.rli
    sudo chmod 0750 /tmp/license.rli
    # Install replicated 
    curl -sSL https://get.replicated.com/docker | sudo bash
    # Check if everything is install as required
    sudo docker ps --format "{{.ID}}: {{.Image}}: {{.Command}}: {{.Ports}}"
