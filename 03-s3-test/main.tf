# 실제 리소스 file

# 역할:
# 이 state(03)가 관리할 리소스 선언

# 03에서의 운영법
# 03의 목적은 backend 전환이기 때문에,
# main.tf는 최소 리소스만 선언.
# 확인용 리소스 하나(테스트 버킷/간단한 IAM) 정도가 적절.
# 본격 인프라는 04/05 같은 실제 스택 폴더에서 관리.

resource "aws_s3_bucket" "test" {
  bucket = "highko99-terraform-test-dev"
}
