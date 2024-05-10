

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.custom_vpc.id
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = length(aws_internet_gateway.igw) == 0 ? null : aws_internet_gateway.igw["igw"].id
}

output "public_subnet_id" {
  description = "Public subnets ID"
  value       = { for k, v in var.public_subnets : k => aws_subnet.public_subnet[k].id }
}

output "private_subnet_id" {
  description = "Private Subnets ID"
  value       = { for k, v in var.private_subnets : k => aws_subnet.private_subnet[k].id }
}

output "natgw_id" {
  description = "NAT Gateway ID"
  value       = { for k, v in var.natgw : k => aws_nat_gateway.natgw[k].id }
}
output "natgw_iep_id" {
  description = "NAT Gateway Elastic IP Allocation ID"
  value       = { for k, v in local.natgw_eip : k => aws_eip.natgw[k].id }
}

output "default_nacl_id" {
  description = "Default NACL ID"
  value       = aws_default_network_acl.custom_vpc.id
}


output "nacl_id" {
  description = "NACL ID"
  value       = { for k, v in var.nacl : k => aws_network_acl.custom_vpc[k].id }

}
output "default_sg_id" {
  description = "Default Security Group ID"
  value       = aws_default_security_group.custom_vpc.id
}

output "sg_id" {
  description = "Security Group ID"
  value       = { for k, v in var.sg : k => aws_security_group.custom_sg[k].id }
}

output "rt_id" {
  description = "Route Tables ID"
  value       = { for k, v in var.rt : k => module.subnet_rt[k].rt_id }
}

output "tgw_subnet_id" {
  description = "Transit Gateway attachment ID"
  value       = { for k, v in var.tgw_attachments : k => module.tgw_subnets[k].tgw_subnet_id }
}

output "tgw_attachment_id" {
  description = "Transit Gateway Attachment ID"
  value       = { for k, v in var.tgw_attachments : k => aws_ec2_transit_gateway_vpc_attachment.custom_vpc[k].id }
}
