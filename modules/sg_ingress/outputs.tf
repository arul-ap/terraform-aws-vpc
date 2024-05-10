
output "sg_rule_id" {
  description = "Security Group Rule ID"
  value       = { for k, v in var.ingress_rules : k => aws_vpc_security_group_ingress_rule.custom_sg[k].id }
}
