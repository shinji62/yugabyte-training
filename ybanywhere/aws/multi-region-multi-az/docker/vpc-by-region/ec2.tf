data "aws_ami" "yb_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_instance" "yb_anywhere_instance" {
  count = var.create_yba_instances ? 1 : 0

  ami = data.aws_ami.yb_ami.id

  // AWS SSM is installed but seems having issue to make yuugabyte working with redirection and so on
  // with tunneling
  // TODO: Fix to use fully private

  associate_public_ip_address = true
  iam_instance_profile        = one(aws_iam_instance_profile.yb_any_inst_profile[*].name)
  instance_type               = var.instance_type
  key_name                    = var.ssh_keypair_name
  vpc_security_group_ids      = [aws_security_group.yb_anywhere_sg.id, aws_security_group.yb_sg.id]
  subnet_id                   = module.vpc.public_subnets[0]
  user_data_base64 = base64encode(templatefile(
    "${path.module}/scripts/cloud-init.yml.tpl",
    {
      replicated_conf      = base64encode(file("${path.module}/files/replicated.conf"))
      license_bucket       = one(aws_s3_bucket.license_bucket[*].id)
      application_settings = base64encode(file("${path.module}/files/application_settings.conf"))
    }
  ))


  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 3
  }

  root_block_device {
    volume_size = var.volume_size
    encrypted   = true
    volume_type = "gp3"
  }


  tags = {
    Name = "${local.name_prefix}-yb_anywhere"
  }

}

