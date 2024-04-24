
resource "aws_route" "natgw_pl" {
  route_table_id             = var.route.rt_id
  destination_prefix_list_id = var.route.pl
  nat_gateway_id             = var.route.natgw
}
