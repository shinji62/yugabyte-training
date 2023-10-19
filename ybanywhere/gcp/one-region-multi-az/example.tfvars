gcp_region    = "asia-northeast1"
project_id    = "yourgcp_project"
instance_type = "n1-standard-4"
default_tags = {
  tag_1  = "value1"
  tag_2  = "value2"

}
resource_prefix                    = "myprefix"
allowed_sources                    = ["mylocalip/32"]
yba_ssh_private_key_path           = "path/to/privatekey/for/ssh/file"
yba_customer_code                  = "admin"
yba_customer_email                 = "myemail@email.com"
yba_customer_name                  = "MyNAME"
yba_application_settings_file_path = "path/to/installer/license/file.pub"
yba_license_file_path              = "path"
yba_ssh_user                       = "ubuntu"
yba_ssh_public_key_path = "path/to/publickey/for/ssh/file.pub"