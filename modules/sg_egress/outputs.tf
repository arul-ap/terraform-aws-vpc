
output "sg_rule_id" {
  description = "Security Group Rule ID"
  value       = { for k, v in var.egress_rules : k => aws_vpc_security_group_egress_rule.custom_sg[k].id }
}
