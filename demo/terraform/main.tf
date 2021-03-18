provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {
}

data "aws_caller_identity" current {
}

resource "aws_kms_key" "parameter_store" {
  description = "Parameter store kms master key"
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_kms_alias" "parameter_store_alias" {
  name = "alias/chamber"
  target_key_id = aws_kms_key.parameter_store.id
}

resource "aws_kms_key" "sops" {
  description = "SOPS kms master key"
  deletion_window_in_days = 10
  enable_key_rotation = true
}

resource "aws_kms_alias" "sops_alias" {
  name = "alias/sops"
  target_key_id = aws_kms_key.sops.id
}

resource "aws_iam_user" "ci_user" {
  name = "parameter_store-pipeline_ci_user"
}

resource "aws_iam_user_policy" "ci_policy" {
  name = "parameter_store-pipeline_ci_policy"
  user = aws_iam_user.ci_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ssm:PutParameter",
                "ssm:DeleteParameter",
                "ssm:GetParameterHistory",
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:DeleteParameters"
            ],
            "Resource": "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/petshop-*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "ssm:DescribeParameters",
            "Resource": "*"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                  "kms:Encrypt",
                  "kms:Decrypt",
                  "kms:ReEncrypt*",
                  "kms:GenerateDataKey*",
                  "kms:DescribeKey"
            ],
            "Resource": "${aws_kms_key.parameter_store.arn}"
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                  "kms:Encrypt",
                  "kms:Decrypt",
                  "kms:ReEncrypt*",
                  "kms:GenerateDataKey*",
                  "kms:DescribeKey"
            ],
            "Resource": "${aws_kms_key.sops.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "ci_user_credentials" {
  user = aws_iam_user.ci_user.name
}
