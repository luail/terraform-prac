terraform {
  backend "s3" {
    bucket       = "highko99-terraform-state-dev"
    key          = "04-eks/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}