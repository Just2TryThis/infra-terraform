# ============================================
# Modules
# ============================================

module "network" {
  source              = "./network"
  env                 = "dev"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  az_a                = "eu-west-3a"
  az_b                = "eu-west-3b"
}

module "sops_kms" {
  source                  = "./kms"
  description             = "Key used by SOPS to encrypt secrets"
  alias                   = "alias/sops-key"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

module "iam" {
  source      = "./iam"
  kms_key_arn = module.sops_kms.key_arn
  username    = "kungfu"
  policy_name = "kungfu"
}

module "auth" {
  source = "./auth"
}

module "ec2_instance" {
  source                   = "./ec2_instance"
  subnet_id                = module.network.public_subnet_id
  vpc_id                   = module.network.vpc_id
  my_ip                    = chomp(data.http.myip.body)
  instance_name            = "kungfu"
  permissions_boundary_arn = module.iam.permissions_boundary_arn
}

module "s3_bucket" {
  source                        = "./s3_bucket"
  bucket_name                   = "labbylab"
  very_secret_access_key_id     = module.iam.access_key_id
  very_secret_access_key_secret = module.iam.access_key_secret
  very_secret_username          = module.iam.username
}

module "cloudtrail" {
  source          = "./cloudtrail"
  bucket_name     = module.s3_bucket.bucket_name
  depends_on      = [module.s3_bucket]
  is_multi_region = true
}

module "cloudwatch" {
  source         = "./cloudwatch"
  bucket_name    = module.s3_bucket.bucket_name
  log_group_name = "/aws/lambda/monLambda"
  depends_on     = [module.s3_bucket]
}

# ============================================
# Data sources
# ============================================

data "http" "myip" {
  url = "http://ipv4.icanhazip.com/"
}

# ============================================
# IAM Users (Esteban & Chintok)
# ============================================

resource "aws_iam_user" "esteban" {
  name = "Esteban"
}

resource "aws_iam_user" "chintok" {
  name = "Chintok"
}

resource "aws_iam_user_group_membership" "esteban_membership" {
  user   = aws_iam_user.esteban.name
  groups = [module.auth.admin_group_name]
}

resource "aws_iam_user_group_membership" "chintok_membership" {
  user   = aws_iam_user.chintok.name
  groups = [module.auth.reader_group_name]
}
