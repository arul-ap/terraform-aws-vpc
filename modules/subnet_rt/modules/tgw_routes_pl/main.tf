
resource "aws_route" "tgw_pl" {
  route_table_id             = var.route.rt_id
  destination_prefix_list_id = var.route.pl
  transit_gateway_id         = var.route.tgw
}
