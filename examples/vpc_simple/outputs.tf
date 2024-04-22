
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "igw_id" {
  value = module.vpc.igw_id
}
output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}
output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "netgw_id" {
  value = module.vpc.natgw_id
}
output "natgw_eip_id" {
  value = module.vpc.natgw_iep_id
}
 output "sg_id" {
   value = module.vpc.sg_id
 }
 
