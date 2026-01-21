// 05-rds/providers.tf
// 해당 부분은 어떤 계정, 어떤 리전에 접속할 것인지에 대한 정의.
provider "aws" {
  region  = var.aws_region
  profile = "dev"
}
