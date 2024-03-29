aws_region_1 = "ap-northeast-1"
aws_region_2 = "ap-southeast-1"
aws_region_3 = "ap-southeast-2"

default_tags = {
  yb_tags1  = "poc"
  yb_tags2  = "poc2"
}
resource_prefix  = "yb-ge"
ssh_keypair_name = "my-key-pair-in-aws"
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