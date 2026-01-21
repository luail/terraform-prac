// 05-rds/backend.tf
terraform {
  backend "s3" {
    bucket       = "highko99-terraform-state-dev"
    key          = "05-rds/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}