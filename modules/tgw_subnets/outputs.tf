
output "tgw_subnet_id" {
  description = "Transit Gateway Subnet ID"
  value = {for k,v in aws_subnet.tgw_subnets: k => aws_subnet.tgw_subnets[k].id}
}
