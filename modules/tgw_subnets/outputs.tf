
output "tgw_subnet_ids" {
  value = [for k,v in aws_subnet.tgw_subnets: v.id]
}
