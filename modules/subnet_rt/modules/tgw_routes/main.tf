
resource "aws_route" "tgw" {
  route_table_id         = var.route.rt_id
  destination_cidr_block = var.route.cidr
  transit_gateway_id     = var.route.tgw
}
