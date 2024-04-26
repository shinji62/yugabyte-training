# # resource "aws_kms_key" "yb_encrypt_master_key" {
# #   description             = "${local.name_prefix}-yb-master-key"
# #   deletion_window_in_days = 30
# #   policy = data.aws_iam_policy_document.kms_key_policy.json
# # }

# # resource "aws_kms_alias" "a" {
# #   name          = "alias/${local.name_prefix}-yb-master-key"
# #   target_key_id = aws_kms_key.yb_encrypt_master_key.key_id
# # }

# data "aws_iam_policy_document" "kms_key_policy" {
# statement {
#   effect = "Allow"
#   principals {
#     type = "AWS"
#     identifiers = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" ]
#   }
#   actions = [ "kms:*" ]
# }


# #   statement {
# #     effect = "Allow"

# #  principals {
# #       type        = "AWS"
# #       identifiers = [""]
# #     }

# #     actions = [
# #       "kms:Encrypt",
# #       "kms:Decrypt",
# #       "kms:GenerateDataKeyWithoutPlaintext",
# #       "kms:DescribeKey",
# #       "kms:DisableKey",
# #       "kms:ScheduleKeyDeletion",
# #       "kms:CreateAlias",
# #       "kms:DeleteAlias",
# #       "kms:UpdateAlias"
# #     ]

# #     resources = ["*" ]
# #   }
# }
# locals {
# user_role =      split("/",data.aws_caller_identity.current.arn)
# }
# data "aws_caller_identity" "current" {}

# data "aws_iam_roles" "roles" {
#  name_regex  = ".*${local.user_role[1]}.*"
#  path_prefix = "/aws-reserved/sso.amazonaws.com/"
# }