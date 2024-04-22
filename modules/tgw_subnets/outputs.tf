
output "tgw_subnet_id" {
  description = "Transit Gateway Subnet ID list"
  value       = [for k, v in aws_subnet.tgw_subnets : aws_subnet.tgw_subnets[k].id]
}
