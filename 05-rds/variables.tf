// 05-rds/variables.tf

// 리전
variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

// eks의 remote state가 저장된 s3 버킷 이름
variable "eks_state_bucket" {
  type = string
}

// eks의 remote state 경로
variable "eks_state_key" {
  type = string
}

// DB 서버 이름
variable "db_identifier" {
  type = string
}

// DB 기본 생성 스키마 이름
variable "db_name" {
  type = string
}

// DB 관리자 계정 ID (보통 admin or root)
variable "db_username" {
  type = string
}

// 관리자 계정 비밀번호
// sensitive = true 옵션으로 화면 출력 방지
variable "db_password" {
  type      = string
  sensitive = true
}

// 내 고정 ip 대역
variable "my_ip_cidr" {
  type = string
}

// DB 스펙
variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}

// DB 스토리지 크기 (GB)
variable "allocated_storage" {
  type    = number
  default = 20
}

// 퍼블릭 액세스
variable "publicly_accessible" {
  type    = bool
  default = true
}

// 소프트웨어 버전(mysql 8.0)
variable "engine_version" {
  type    = string
  default = "8.0"
}
