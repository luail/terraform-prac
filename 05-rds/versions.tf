// 05-rds/versions.tf
terraform {
  required_version = "~> 1.14.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8"
    }
  }
}
