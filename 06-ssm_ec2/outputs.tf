output "ssm_ec2_sg_id" {
  value = aws_security_group.ssm_ec2_sg.id
}

output "ssm_endpoint_sg_id" {
  value = aws_security_group.ssm_endpoint_sg.id
}

output "ssm_ec2_instance_id" {
  value = aws_instance.ssm_ec2.id
}
