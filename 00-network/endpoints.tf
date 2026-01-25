# SSM VPC Interface Endpoints (NAT 없이 private subnet에서 SSM 접속)

resource "aws_security_group" "vpce" {
  name        = "${local.name}-vpce-sg"
  description = "Security group for VPC interface endpoints"
  vpc_id      = module.vpc.vpc_id

  # 인바운드는 '관리용 EC2 SG'에서만 443 허용하는 게 정석인데,
  # 지금은 admin EC2 SG가 아직 없으니 우선 VPC CIDR로 제한.
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

locals {
  interface_endpoints = toset([
    "ssm",
    "ec2messages",
    "ssmmessages",
    "sts",
    # "logs", # 필요하면 주석 해제
  ])
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_endpoints

  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.vpce.id]

  tags = merge(local.tags, {
    Name = "${local.name}-vpce-${each.key}"
  })
}
