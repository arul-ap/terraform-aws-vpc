
resource "aws_vpc_security_group_egress_rule" "custom_sg" {
  for_each                     = var.egress_rules
  description                  = each.key
  security_group_id            = var.sg_id
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.sg_id
  prefix_list_id               = each.value.sg_id == null ? each.value.pf_list_id : null
  cidr_ipv4                    = each.value.sg_id == null && each.value.pf_list_id == null ? each.value.target_cidr : null
  from_port                    = each.value.protocol == -1 ? null : each.value.port_range_start
  to_port                      = each.value.protocol == -1 ? null : each.value.port_range_end
  tags = {
    Name = "${var.name-prefix}-${each.key}"
  }
}
