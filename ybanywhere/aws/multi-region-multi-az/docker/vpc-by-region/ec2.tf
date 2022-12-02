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
      replicated_conf       = base64encode(file("${path.module}/files/replicated.conf"))
      license_bucket        = one(aws_s3_bucket.license_bucket[*].id)
      application_settings  = base64encode(file("${path.module}/files/application_settings.conf"))
      replicated_password   = local.replicated_password
      replicated_seq_number = var.replicated_seq_number
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


//If we want to test on prem node
resource "aws_instance" "yb_anywhere_node_on_prem" {

  ami   = data.aws_ami.yb_ami.id
  count = var.node_on_prem_test

  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.ssh_keypair_name
  vpc_security_group_ids      = [aws_security_group.yb_anywhere_sg.id, aws_security_group.yb_sg.id]
  iam_instance_profile        = one(aws_iam_instance_profile.yb_node_inst_profile[*].name)
  subnet_id                   = module.vpc.public_subnets[index(module.vpc.azs, element(module.vpc.azs, count.index))]

  user_data_base64 = base64encode(templatefile(
    "${path.module}/scripts/cloud-init-node.yml.tpl",
    {
      public_key_node = file(local.node_ssh_key)
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
    Name = "${local.name_prefix}-yb_anywhere-${count.index}"
  }

}

resource "aws_volume_attachment" "yb_anywhere_node_attachement" {
  count       = var.node_on_prem_test
  device_name = "/dev/sdh"
  volume_id   = element(aws_ebs_volume.yb_anywhere_node_disk.*.id, count.index)
  instance_id = element(aws_instance.yb_anywhere_node_on_prem.*.id, count.index)
}

resource "aws_ebs_volume" "yb_anywhere_node_disk" {
  count             = var.node_on_prem_test
  availability_zone = element(module.vpc.azs, count.index)
  type              = "gp3"
  size              = 100
}
