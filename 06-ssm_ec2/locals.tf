locals {
  name = "${var.project}-${var.env}-ssm_ec2"

  tags = {
    Project     = var.project
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}