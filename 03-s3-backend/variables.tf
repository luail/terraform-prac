# 외부와 연결되는 file

# 역할:
# 이 스택이 외부 입력을 받는 지점

# 분리 이유:
# 03의 backend 설정은 변수를 못 쓰는 경우가 많음(초기화 시점 문제)
# 따라서 variables를 과하게 두면 이슈 생길 수 있음.

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}
