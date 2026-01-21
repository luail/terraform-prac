// 05-rds/data.tf
// 해당 부분은 eks에서 생성한 리소스들을 참조(eks의 remote state를 가져옴)하기 위한 정의
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = var.eks_state_bucket
    key    = var.eks_state_key
    region = var.aws_region
  }
}