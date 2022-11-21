#cloud-config
package_update: true
package_upgrade: true

packages:
  - curl
  - wget
  - awscli
  - jq

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
     # Get public IP
     export PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
     cat /tmp/settings.conf | jq ".hostname.value=env.PUBLIC_IP" | sudo tee /tmp/settings.conf
  - |
     # Change password for replicated
     cat /etc/replicated.conf | jq '.DaemonAuthenticationPassword="${replicated_password}"' | sudo tee /etc/replicated.conf
  - |
    mkdir /tmp/ssm && cd /tmp/ssm
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
    sudo dpkg -i amazon-ssm-agent.deb
    sudo systemctl enable amazon-ssm-agent
  - |
    # Get License from s3
    aws s3 cp s3://${license_bucket}/license.rli /tmp/license.rli
    sudo chown root:root /tmp/license.rli
    sudo chmod 0750 /tmp/license.rli
    # Install replicated 
    curl -sSL https://get.replicated.com/docker | sudo bash
    # Check if everything is install as required
    sudo docker ps --format "{{.ID}}: {{.Image}}: {{.Command}}: {{.Ports}}"
