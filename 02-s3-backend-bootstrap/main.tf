# 목적: Terraform이 앞으로 사용할 원격 state 저장소(S3)를 최초로 만드는 프로젝트.
# 별도 폴더로 분리한 이유:
# Terraform에서 S3 backend로 쓰려면 backend "s3" 설정이 필요.
# backend가 참조하는 S3 버킷은 미리 존재해야 함.
# 1. backend를 쓰려면 S3가 있어야함.
# 2. S3를 Terraform으로 만드려면 backend 없이 시작해야 함.
# 따라서 로컬 state로 S3만 만들고 이후 S3 backend를 붙임.

# terraform 블록에서 terraform 버전 몇 이상인지 명시.
# 특히 provider는 AWS API 스펙 변화/버그 픽스 영향이 크기에 버전 합의하는 내용의 코드.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

# provider "aws"가 필요한 이유는 키를 코드에 박지 않고 AWS CLI profile로 가져옴.
# 인증은 .tf에 키를 쓰는것이 아닌 AWS CLI profile로 가져올 것.
provider "aws" {
  region  = "ap-northeast-2"
  profile = "dev" # ~/.aws/credentials에 있는 프로파일 이름을 의미.
}

# Terraform state 저장소용 S3 버킷
resource "aws_s3_bucket" "tf_state" {
  bucket = "highko99-terraform-state-dev" # 전 세계 유니크해야 함
}

# 퍼블릭 액세스 차단 (state는 절대 공개되면 안 됨)
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 버전닝
# state가 잘못 갱신된다면 되돌려야 하므로
# 버전닝이 일종의 백업/롤백 안전장치.
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 기본 암호화 (SSE-S3: AES256)
# state 안에 리소스 정보/내부 값들이 들어갈 수 있기에 암호화적용.
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# output을 넣음으로써 다음 단계(03-main)에서 backend 설정에 버킷 이름 필요
# output이 있으면 내가 뭘 만들었는지 바로 확인 가능.
output "tf_state_bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}

output "tf_state_bucket_arn" {
  value = aws_s3_bucket.tf_state.arn
}
