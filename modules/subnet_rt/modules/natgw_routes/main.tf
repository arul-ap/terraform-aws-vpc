
resource "aws_route" "natgw" {
  route_table_id = var.route.rt_id
  destination_cidr_block = var.route.cidr
  nat_gateway_id = var.route.natgw
}
