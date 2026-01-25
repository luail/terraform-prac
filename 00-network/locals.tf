data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name = "${var.project}-${var.env}-network"

  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  tags = {
    Project     = var.project
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}