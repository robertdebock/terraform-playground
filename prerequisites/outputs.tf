output "instance_vpc_id" {
  description = "The ID of the VPC."
  value = aws_vpc.default.id
}

output "instance_subnet_id" {
  description = "The ID of the subnet."
  value = aws_subnet.default.id
}

output "instance_security_group_id" {
  description = "The ID of the security group."
  value = aws_security_group.default.id
}

output "instance_key_pair_id" {
  description = "The ID of the key pair."
  value = aws_key_pair.default.key_pair_id
}
