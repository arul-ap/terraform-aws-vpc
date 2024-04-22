
resource "aws_route" "pcx" {
  route_table_id            = var.route.rt_id
  destination_cidr_block    = var.route.cidr
  vpc_peering_connection_id = var.route.pcx
}
