# 목적: Terraform이 앞으로 사용할 원격 state 저장소(S3)를 최초로 만드는 프로젝트.
# 별도 폴더로 분리한 이유:
# Terraform에서 S3 backend로 쓰려면 backend "s3" 설정이 필요.
# backend가 참조하는 S3 버킷은 미리 존재해야 함.
# 1. backend를 쓰려면 S3가 있어야함.
# 2. S3를 Terraform으로 만드려면 backend 없이 시작해야 함.
# 따라서 로컬 state로 S3만 만들고 이후 S3 backend를 붙임.

# terraform 블록: 1.5.x 버전만 허용
# AWS provider 5.x 버전만 허용
# >=를 쓸 경우 의도치 않은 최신 버전이 설치될 수 있어 ~>를 사용.
# 팀에서 같은 코드로 같은 결과를 내기 위해 버전 고정.
terraform {
  required_version = "~> 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

# aws configure로 설정한 프로파일과 리전을 사용.
# aws configuere --profile dev로 명령어를 실행해 프로파일 생성 필요.
# 기존 aws configure는 default 프로파일을 생성.
# 실무에서는 profile을 코드에 고정하지 않고 환경 변수 또는 IAM Role 기반 인증 사용.
provider "aws" {
  region  = "ap-northeast-2"
  profile = "dev" # ~/.aws/credentials에 있는 프로파일 이름을 의미.
}

# Terraform state 저장소용 S3 버킷
# resource의 흐름.
# 1. aws_s3_bucket이라는 aws provider에 선언되어 있는 provider type을 사용.
# 2. terraform 코드 내에서 tf_state라는 이름으로 이 리소스를 참조.
# 3. 아래에 aws_s3_bucket_public_access_block provider type에서 tf_state 리소스를 참조하여 해당 버킷에 퍼블릭 액세스 차단 설정을 함.

# lifecycle prevent_destroy 설정:
# 실수로 terraform destroy 명령어를 실행하여 S3 버킷이 삭제되는 것을 방지.
# S3 버킷을 정말로 삭제하려면 해당 lifecycle 블록을 제거 후
# terraform apply 실행. 이 단계에서는 아직 삭제 안됨. 단지 삭제 가능 상태로 바뀜.
# 이후 terraform destroy 명령어를 실행해야 실제로 삭제됨.
# 한번의 실수로 코드 삭제, 모듈 제거, 변수 변경 등의 중요 리소스가 날아가는 사고 방지.
resource "aws_s3_bucket" "tf_state" {
  bucket = "highko99-terraform-state-dev" # 전 세계 유니크해야 함
  
    lifecycle {
    prevent_destroy = true
  }
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
