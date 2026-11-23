output "key_pair_name" {
  description = "Name of the SSH key pair registered in AWS"
  value       = aws_key_pair.ec2_key.key_name
}

output "private_key_file" {
  description = "Local path of the generated private SSH key"
  value       = local_file.private_key.filename
}