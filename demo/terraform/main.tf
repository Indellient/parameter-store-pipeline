provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "parameter_store" {
  description             = "Parameter store kms master key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "parameter_store_alias" {
  name          = "alias/chamber"
  target_key_id = aws_kms_key.parameter_store.id
}

resource "aws_kms_key" "sops" {
  description             = "SOPS kms master key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "sops_alias" {
  name          = "alias/sops"
  target_key_id = aws_kms_key.sops.id
}
