# 인증/리전/기본 태그 같은 실행 컨텍스트 file

# 역할:
# AWS region
# 인증 방식(profile/env/IAM role)
# default tags 같은 공통 정책

# 분리 이유:
# provider 설정은 리소스 전체에 영향을 줌 (리전이 바뀔 경우 전체를 재생성해야 할 수도 있음).
# backend와 같은 초기화 이슈는 아니지만, 영향 범위가 큼.
# 따라서 리소스와 분리하여 이 프로젝트의 실행 환경이라는 것을 명확히 하기 위함.

provider "aws" {
  region  = "ap-northeast-2"
  profile = "dev"
}
