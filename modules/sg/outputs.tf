
output "sg_id" {
  description = "Security Group ID"
  value       = aws_security_group.custom_sg.id
}
