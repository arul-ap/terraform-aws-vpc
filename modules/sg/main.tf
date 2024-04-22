

resource "aws_security_group" "custom_sg" {
    vpc_id = var.vpc_id
    name = "${var.name-prefix}-${var.sg_name}"
    description = var.sg.description
    tags = {
        Name = "${var.name-prefix}-${var.sg_name}"
    }
}
resource "aws_vpc_security_group_ingress_rule" "custom_sg" {
  for_each = var.sg.ingress_rules
  description = each.key
  security_group_id = aws_security_group.custom_sg.id
  ip_protocol = each.value.protocol
  referenced_security_group_id = each.value.sg == "self"? aws_security_group.custom_sg.id : each.value.sg
  prefix_list_id = each.value.sg == null? each.value.pf_list : null
  cidr_ipv4 = each.value.sg == null && each.value.pf_list == null ? each.value.source_cidr : null
  from_port = each.value.protocol == -1 ? null : each.value.port_range_start
  to_port = each.value.protocol == -1 ? null : each.value.port_range_end
  tags = {
    Name = "${var.name-prefix}-${each.key}"
  }
}
resource "aws_vpc_security_group_egress_rule" "custom_sg" {
  for_each = var.sg.egress_rules
  description = each.key
  security_group_id = aws_security_group.custom_sg.id
  ip_protocol = each.value.protocol
  referenced_security_group_id = each.value.sg == "self"? aws_security_group.custom_sg.id : each.value.sg
  prefix_list_id = each.value.sg == null? each.value.pf_list : null
  cidr_ipv4 = each.value.sg == null && each.value.pf_list == null ? each.value.target_cidr : null
  from_port = each.value.protocol == -1 ? null : each.value.port_range_start
  to_port = each.value.protocol == -1 ? null : each.value.port_range_end
  tags = {
    Name = "${var.name-prefix}-${each.key}"
  }
}
