
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}
output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.vpc.public_subnet_id
}
output "private_subnet_id" {
  description = "Private subnet ID"
  value       = module.vpc.private_subnet_id
}

output "natgw_id" {
  description = "NAT gateway ID"
  value       = module.vpc.natgw_id
}
output "natgw_eip_id" {
  description = "Elastic IP Allocation ID for NAT gateway"
  value       = module.vpc.natgw_iep_id
}


output "default_nacl_id" {
  description = "Default NACL ID"
  value       = module.vpc.default_nacl_id
}


output "nacl_id" {
  description = "NACL ID"
  value       = module.vpc.nacl_id

}
output "default_sg_id" {
  description = "Default Security Group ID"
  value       = module.vpc.default_sg_id
}


output "sg_id" {
  description = "Security Group ID"
  value       = module.vpc.sg_id
}


output "rt_id" {
  description = "Route Tables ID"
  value       = module.vpc.rt_id
}

output "tgw_subnet_id" {
  description = "Transit Gateway attachment ID"
  value       = module.vpc.tgw_subnet_id
}

output "tgw_attachment_id" {
  description = "Transit Gateway Attachment ID"
  value       = module.vpc.tgw_attachment_id
}
