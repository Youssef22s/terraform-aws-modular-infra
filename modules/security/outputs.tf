output "sg_id" {
  description = "ID of the Web Security Group"
  value       = aws_security_group.web_sg.id
}