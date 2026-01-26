module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.network.outputs.private_subnets
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  endpoints = {
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
    }

    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
    }

    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
    }
  }

  tags = local.tags
}
