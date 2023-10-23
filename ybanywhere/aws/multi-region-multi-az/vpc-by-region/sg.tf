#tfsec:ignore:aws-ec2-add-description-to-security-group
resource "aws_security_group" "yb_anywhere_sg" {

  name   = "${local.name_prefix}-yb_any_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = var.allowed_sources
  }

  dynamic "ingress" {
    for_each = toset(local.yb_anywhere_port)
    #tfsec:ignore:aws-ec2-add-description-to-security-group-rule
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = var.allowed_sources
      protocol    = "tcp"
    }
  }

  #tfsec:ignore:aws-ec2-add-description-to-security-group-rule
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #tfsec:ignore:aws-ec2-no-public-egress-sgr
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "${local.name_prefix}-yb_any_sg"
  }
}


#tfsec:ignore:aws-ec2-add-description-to-security-group
resource "aws_security_group" "yb_sg" {

  name   = "${local.name_prefix}-yb_sg_group"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = var.allowed_sources
  }

  dynamic "ingress" {
    for_each = toset(local.yb_ports)
    #tfsec:ignore:aws-ec2-add-description-to-security-group-rule
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = local.allowed_sources
      protocol    = "tcp"
    }
  }
  #tfsec:ignore:aws-ec2-add-description-to-security-group-rule
  egress {
    from_port = 0
    to_port   = 0
    #tfsec:ignore:aws-ec2-no-public-egress-sgr
    #tfsec:ignore:aws-ec2-no-public-egress-sgr
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "${local.name_prefix}-yb_sg_group"
  }
}
