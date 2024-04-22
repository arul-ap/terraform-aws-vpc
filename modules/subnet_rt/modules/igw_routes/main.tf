

resource "aws_route" "igw" {
  route_table_id = var.route.rt_id
  destination_cidr_block = var.route.cidr
  gateway_id = var.route.igw
}
