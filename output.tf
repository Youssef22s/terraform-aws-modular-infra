output "key_pair_name" {
  description = "Name of the SSH key pair registered in AWS"
  value       = aws_key_pair.ec2_key.key_name
}

output "private_key_file" {
  description = "Local path of the generated private SSH key"
  value       = local_file.private_key.filename
}

output "vpc_id" {
  description = "VPC ID created by network module"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs created by network module"
  value       = module.network.public_subnet_ids
}