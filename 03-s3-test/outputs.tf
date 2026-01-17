# 외부로 내보내는 file

# 역할:
# 이 스택이 외부로 내보내는 값

# 분리 이유:
# 상태 확인용 정도의 최소화하기 위함.

output "example_bucket_name" {
  value = aws_s3_bucket.test.bucket
}
