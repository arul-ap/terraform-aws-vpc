
resource "aws_route" "pcx_pl" {
  route_table_id             = var.route.rt_id
  destination_prefix_list_id = var.route.pl
  vpc_peering_connection_id  = var.route.pcx
}
