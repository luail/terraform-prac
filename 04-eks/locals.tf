// 04-eks/locals.tf
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name = "${var.project}-${var.env}-eks"

  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  tags = {
    Project     = var.project
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}

// 내부 계산 및 표준화용 local 변수 정의
