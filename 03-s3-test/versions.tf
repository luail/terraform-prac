# 팀의 실행 환경 고정 file

# 역할:
# Terraform CLI 버전 범위 고정
# provider 버전 고정

# 분리 이유:
# 인프라 소스가 아닌 도구 체계.
# 팀원이 들어올 경우 제일 먼저 봐야 하는 것이 버전 정책
# provider 업그레이드/다운그레이드는 리소스 변경을 유발할 수 있어서,
# 리소스 코드 옆에서 바뀔 경우 위험.

terraform {
  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}
