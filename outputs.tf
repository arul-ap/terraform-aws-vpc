

output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.custom_vpc.id
}


output "igw_id" {
    description = "Internet Gateway ID"
    value = length(aws_internet_gateway.igw) == 0? null : aws_internet_gateway.igw["igw"].id
}

output "public_subnet_id" {
    description = "Public subnets ID"
  value = { for key,value in var.public_subnets: key => aws_subnet.public_subnet[key].id}
}

output "private_subnet_id" {
    description = "Private Subnets ID"
  value = {for key,value in var.private_subnets: key => aws_subnet.private_subnet[key].id}
}

output "natgw_id" {
    description = "NAT Gateway ID"
  value = {for k,v in var.natgw: k => aws_nat_gateway.natgw[k].id}
}
output "natgw_iep_id" {
    description = "NAT Gateway Elastic IP"
  value = {for k,v in local.natgw_eip: k => aws_eip.natgw[k].id}
}

output "sg_id" {
    description = "Security Group ID"
  value = {for k,v in var.sg: k => module.sg[k].sg_id}
}
