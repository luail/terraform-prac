# State 운용 규칙 file

# 역할:
# state가 저장될 위치 (S3 버킷, key)
# 락 사용 여부(use_lockfile)
# 암호화 사용(encrypt)
# (필요시) workspace_key_prefix 같은 state 분리 전략

# 분리 이유:
# backend 설정은 terraform init 시점에 먼저 평가되고,
# 변경하면 state 마이그레이션/재초기화 같은 큰 사건이 발생됨.
# 따라서 다른 리소스 코드와 섞이면 일반 변경처럼 보여 사고 가능성 있음.

terraform {
  backend "s3" {
    bucket       = "highko99-terraform-state-dev"
    key          = "03-s3-test/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}