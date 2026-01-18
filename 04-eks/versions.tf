// 04-eks/versions.tf
terraform {
  required_version = "= 1.14.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8"
    }
  }
}

// 메이저/마이너 버전까지 확실하게 고정.