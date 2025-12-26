terraform {
  required_version = ">= 1.5.0"
}

# 외부 입력값으로 terraform은 값을 외부에서 주입받을 수 있다.
# default는 값이 없을 경우의 default이다.
variable "env" {
  type = string
  default = "dev"
}

# locals는 Terraform 내부 계산용.
# 이름 규칙, 태그 규칙 만들 때 핵심이다.
locals {
  service_name = "terraform-practice"
  full_name = "${local.service_name}-${var.env}"
}

output "full_name" {
  value = local.full_name
}
