
output "hostnames" {
  description = "The hostnames of the instances."
  value = aws_route53_record.default[*].fqdn
}

output "instruction" {
  description = "Instructions for connecting to the instances."
  value = "Connect to the instance using the 'lab' user and 'lab' password."
}
