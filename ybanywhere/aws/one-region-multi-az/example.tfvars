aws_region_1 = "ap-northeast-1"
aws_region_2 = "ap-southeast-1"
aws_region_3 = "ap-southeast-2"

default_tags = {
  yb_tags1  = "poc"
  yb_tags2  = "poc2"
}
resource_prefix  = "yb-ge"
ssh_keypair_name = "my-key-pair-in-aws"
license_path     = "/home/gwenn/license.file"
allowed_sources  = ["169.1.1.1/32"]
