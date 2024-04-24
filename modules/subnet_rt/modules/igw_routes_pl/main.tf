

resource "aws_route" "igw_pl" {
  route_table_id             = var.route.rt_id
  destination_prefix_list_id = var.route.pl
  gateway_id                 = var.route.igw
}
