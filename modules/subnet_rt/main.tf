
resource "aws_route_table" "subnet_rt" {
  vpc_id = var.rt.vpc_id
  tags = var.rt.tags
}

resource "aws_route_table_association" "subnet_rt" {
  for_each = var.rt.subnet_ids
  subnet_id = each.value
  route_table_id = aws_route_table.subnet_rt.id
}

locals {
  igw_routes = {for k,v in var.routes: k => v if v.gw_type == "igw"}
}
module "igw_routes" {
  for_each = local.igw_routes
  source = "./modules/igw_routes"
  route = {
    rt_id = aws_route_table.subnet_rt.id
    cidr = each.value.cidr
    igw = each.value.gw_id
  }
}

locals {
  natgw_routes = {for k,v in var.routes: k => v if v.gw_type == "natgw"}
}
module "natgw_routes" {
  for_each = local.natgw_routes
  source = "./modules/natgw_routes"
  route = {
    rt_id = aws_route_table.subnet_rt.id
    cidr = each.value.cidr
    natgw = each.value.gw_id
  }
}
