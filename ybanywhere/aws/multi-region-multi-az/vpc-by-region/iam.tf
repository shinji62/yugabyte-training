
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "yb_anywhere_policy_doc" {
  count = var.create_yba_instances ? 1 : var.create_yba_policy ? 1 : 0
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:ImportVolume",
      "ec2:ModifyVolumeAttribute",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceAttribute",
      "ec2:CreateKeyPair",
      "ec2:DescribeVolumesModifications",
      "ec2:DeleteVolume",
      "ec2:DescribeVolumeStatus",
      "ec2:StartInstances",
      "ec2:DescribeAvailabilityZones",
      "ec2:CreateSecurityGroup",
      "ec2:DescribeVolumes",
      "ec2:ModifyInstanceAttribute",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeInstanceStatus",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:TerminateInstances",
      "ec2:AssignIpv6Addresses",
      "ec2:ImportKeyPair",
      "ec2:DescribeTags",
      "ec2:CreateTags",
      "ec2:RunInstances",
      "ec2:AssignPrivateIpAddresses",
      "ec2:StopInstances",
      "ec2:AllocateAddress",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeSecurityGroups",
      "ec2:CreateVolume",
      "ec2:EnableVolumeIO",
      "ec2:DescribeImages",
      "ec2:DescribeVpcs",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSubnets",
      "ec2:DeleteKeyPair",
      "ec2:DescribeVpcPeeringConnections",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInternetGateways",
      "ec2:AssociateRouteTable",
      "ec2:AttachInternetGateway",
      "ec2:CreateInternetGateway",
      "ec2:CreateRoute",
      "ec2:CreateSubnet",
      "ec2:CreateVpc",
      "ec2:CreateVpcPeeringConnection",
      "ec2:AcceptVpcPeeringConnection",
      "ec2:DisassociateRouteTable",
      "ec2:ModifyVpcAttribute",
      "ec2:GetConsoleOutput",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeInstanceTypes",
      "iam:GetRole"
    ]

    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
}

resource "aws_iam_policy" "yb_anywhere_policy" {
  count  = var.create_yba_instances ? 1 : var.create_yba_policy ? 1 : 0
  name   = "${local.name_prefix}-ybw-inst-policy"
  policy = one(data.aws_iam_policy_document.yb_anywhere_policy_doc[*].json)
}

# Yugabyte Anywhere instance Role
resource "aws_iam_role" "yb_anywhere_role" {
  count              = var.create_yba_instances ? 1 : 0
  name               = "${local.name_prefix}-ybw-role"
  path               = "/"
  description        = "YB anywhere instance policy EC2 Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_instance_profile" "yb_any_inst_profile" {
  count = var.create_yba_instances ? 1 : 0
  name  = "${local.name_prefix}-ybw-inst-profile"
  role  = one(aws_iam_role.yb_anywhere_role[*].name)
}

resource "aws_iam_role_policy_attachment" "yb-anywhere-ssm-attach" {
  count      = var.create_yba_instances ? 1 : 0
  role       = one(aws_iam_role.yb_anywhere_role[*].name)
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "yb-anywhere-policy-attach" {
  count      = var.create_yba_instances ? 1 : 0
  role       = one(aws_iam_role.yb_anywhere_role[*].name)
  policy_arn = one(aws_iam_policy.yb_anywhere_policy[*].arn)
}


### Role for the nodes in case of on-prem testing 


resource "aws_iam_role" "yb_node_role" {
  count              = (var.node_on_prem_test != 0 ? 1 : 0)
  name               = "${local.name_prefix}-yb-node-role"
  path               = "/"
  description        = "YB node instance policy EC2 Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_instance_profile" "yb_node_inst_profile" {
  count = (var.node_on_prem_test != 0 ? 1 : 0)
  name  = "${local.name_prefix}-ybw-node-profile"
  role  = one(aws_iam_role.yb_node_role[*].name)
}

resource "aws_iam_role_policy_attachment" "yb-node-ssm-attach" {
  count      = (var.node_on_prem_test != 0 ? 1 : 0)
  role       = one(aws_iam_role.yb_node_role[*].name)
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


data "aws_iam_policy_document" "backup_policy" {
  count = var.create_backup_bucket ? 1 : 0
  statement {
    effect = "Allow"

    actions = [
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::${one(aws_s3_bucket.backup_bucket[*].id)}",
      "arn:aws:s3:::${one(aws_s3_bucket.backup_bucket[*].id)}/*"
    ]
  }
}

resource "aws_iam_policy" "yb_any_backup_s3_policy" {
  count  = var.create_backup_bucket ? 1 : 0
  name   = "${local.name_prefix}-ybw-inst-s3-policy"
  policy = one(data.aws_iam_policy_document.backup_policy[*].json)
}

resource "aws_iam_role_policy_attachment" "yb-anywhere-s3-attach" {
  count      = var.create_backup_bucket ? (var.create_yba_instances ? 1 : 0) : 0
  role       = one(aws_iam_role.yb_anywhere_role[*].name)
  policy_arn = one(aws_iam_policy.yb_any_backup_s3_policy[*].arn)
}


## KMS

data "aws_iam_policy_document" "yb_anywhere_kms" {
  count = var.create_kms_permission ? 1 : 0
  statement {
    effect = "Allow"

    actions = [
      "kms:CreateKey",
      "kms:ListAliases",
      "kms:ListKeys",
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:UpdateAlias",
      "kms:TagResource"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "yb_any_kms_policy" {
  count  = var.create_kms_permission ? 1 : 0
  name   = "${local.name_prefix}-ybw-inst-kms-policy"
  policy = one(data.aws_iam_policy_document.yb_anywhere_kms[*].json)
}
resource "aws_iam_role_policy_attachment" "yb-anywhere-kms-attach" {
  count      = var.create_kms_permission ? (var.create_yba_instances ? 1 : 0) : 0
  role       = one(aws_iam_role.yb_anywhere_role[*].name)
  policy_arn = one(aws_iam_policy.yb_any_kms_policy[*].arn)
}
