terraform {
  backend "s3" {
    bucket       = "highko99-terraform-state-dev"
    key          = "06-ssm_ec2/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}