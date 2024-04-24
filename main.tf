
locals {
  name-prefix = lower("${var.org}-${var.proj}-${var.env}") // prefix for naming resources
}

data "aws_region" "current" {}


resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(var.vpc_tags, {
    Name = "${local.name-prefix}-${var.vpc_name}"
  })
}

locals {
  igw = length(var.public_subnets) == 0 ? {} : { "igw" = true } // Decide to create IGW if any public subnets
}

resource "aws_internet_gateway" "igw" {
  for_each = local.igw
  vpc_id   = aws_vpc.custom_vpc.id
  tags = merge(var.vpc_tags, {
    Name = "${local.name-prefix}-${var.vpc_name}-igw"
  })
}



resource "aws_subnet" "public_subnet" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = each.value.subnet_cidr
  availability_zone = "${data.aws_region.current.name}${each.value.az}"
  tags = merge(each.value.tags, {
    Name = "${local.name-prefix}-${each.key}"
  })
}


resource "aws_subnet" "private_subnet" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = each.value.subnet_cidr
  availability_zone = "${data.aws_region.current.name}${each.value.az}"
  tags = merge(each.value.tags, {
    Name = "${local.name-prefix}-${each.key}"
  })
}

locals {
  natgw_eip = { for k, v in var.natgw : k => v if v.type == "public" } // select eip for public nat gw
}

resource "aws_eip" "natgw" {
  for_each = local.natgw_eip
  tags = merge(each.value.tags, {
    Name = "${local.name-prefix}-${each.key}-eip"
  })
}

resource "aws_nat_gateway" "natgw" {
  for_each          = var.natgw
  subnet_id         = aws_subnet.public_subnet[each.value.subnet].id
  connectivity_type = each.value.type
  allocation_id     = each.value.type == "public" ? aws_eip.natgw[each.key].id : null
  tags = merge(each.value.tags, {
    Name = "${local.name-prefix}-${each.key}"
  })
}


resource "aws_default_network_acl" "custom_vpc" {
  default_network_acl_id = aws_vpc.custom_vpc.default_network_acl_id
  dynamic "ingress" {
    for_each = var.default_nacl_ingress
    content {
      rule_no    = ingress.key
      protocol   = ingress.value.protocol
      cidr_block = ingress.value.source
      from_port  = ingress.value.port_range_start
      to_port    = ingress.value.port_range_end
      action     = ingress.value.action
    }
  }
  dynamic "egress" {
    for_each = var.default_nacl_egress
    content {
      rule_no    = egress.key
      protocol   = egress.value.protocol
      cidr_block = egress.value.target
      from_port  = egress.value.port_range_start
      to_port    = egress.value.port_range_end
      action     = egress.value.action
    }
  }
  tags = {
    Name = "${local.name-prefix}-${var.vpc_name}-default-nacl"
  }
  lifecycle {
    ignore_changes = [subnet_ids]
  }
}



resource "aws_network_acl" "custom_vpc" {
  for_each = var.nacl
  vpc_id   = aws_vpc.custom_vpc.id
  subnet_ids = concat(length(each.value.private_subnets) == 0 ? [] : [for i in each.value.private_subnets : aws_subnet.private_subnet[i].id],
  length(each.value.public_subnets) == 0 ? [] : [for i in each.value.public_subnets : aws_subnet.public_subnet[i].id])
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      rule_no    = ingress.key
      protocol   = ingress.value.protocol
      cidr_block = ingress.value.source
      from_port  = ingress.value.port_range_start
      to_port    = ingress.value.port_range_end
      action     = ingress.value.action
    }
  }
  dynamic "egress" {
    for_each = each.value.egress
    content {
      rule_no    = egress.key
      protocol   = egress.value.protocol
      cidr_block = egress.value.target
      from_port  = egress.value.port_range_start
      to_port    = egress.value.port_range_end
      action     = egress.value.action
    }
  }
  tags = {
    Name = "${local.name-prefix}-${each.key}"
  }
}
resource "aws_default_security_group" "custom_vpc" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "${local.name-prefix}-${var.vpc_name}-default-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "default_sg" {
  for_each                     = var.default_sg_ingress
  description                  = each.key
  security_group_id            = aws_default_security_group.custom_vpc.id
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.sg == "self" ? aws_default_security_group.custom_vpc.id : each.value.sg
  prefix_list_id               = each.value.sg == null ? each.value.pf_list : null
  cidr_ipv4                    = each.value.sg == null && each.value.pf_list == null ? each.value.source_cidr : null
  from_port                    = each.value.protocol == -1 ? null : each.value.port_range_start
  to_port                      = each.value.protocol == -1 ? null : each.value.port_range_end
  tags = {
    Name = "${local.name-prefix}-${each.key}"
  }
}
resource "aws_vpc_security_group_egress_rule" "default_sg" {
  for_each                     = var.default_sg_egress
  description                  = each.key
  security_group_id            = aws_default_security_group.custom_vpc.id
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.sg == "self" ? aws_default_security_group.custom_vpc.id : each.value.sg
  prefix_list_id               = each.value.sg == null ? each.value.pf_list : null
  cidr_ipv4                    = each.value.sg == null && each.value.pf_list == null ? each.value.target_cidr : null
  from_port                    = each.value.protocol == -1 ? null : each.value.port_range_start
  to_port                      = each.value.protocol == -1 ? null : each.value.port_range_end
  tags = {
    Name = "${local.name-prefix}-${each.key}"
  }
}

module "sg" {
  for_each    = var.sg
  source      = "./modules/sg"
  vpc_id      = aws_vpc.custom_vpc.id
  sg_name     = each.key
  sg          = each.value
  name-prefix = local.name-prefix
}

resource "aws_default_route_table" "custom_vpc" {
  default_route_table_id = aws_vpc.custom_vpc.default_route_table_id
  tags = {
    Name = "${local.name-prefix}-${var.vpc_name}-default-rt"
  }
}

module "subnet_rt" {
  for_each = var.rt
  source   = "./modules/subnet_rt"
  rt = {
    vpc_id = aws_vpc.custom_vpc.id
    subnet_ids = merge(length(each.value.private_subnets) == 0 ? {} : { for i in each.value.private_subnets : i => aws_subnet.private_subnet[i].id },
    length(each.value.public_subnets) == 0 ? {} : { for i in each.value.public_subnets : i => aws_subnet.public_subnet[i].id })
    tags = merge(each.value.tags,
    { "Name" = "${local.name-prefix}-${each.key}" })
  }
  routes = merge({ for k, v in each.value.routes :
    k => {
      cidr    = v.destination_cidr
      pl      = v.prefix_list_id
      gw_type = v.gw_type
    gw_id = aws_internet_gateway.igw["igw"].id } if v.gw_type == "igw" },
    { for k, v in each.value.routes :
      k => {
        cidr    = v.destination_cidr
        pl      = v.prefix_list_id
        gw_type = v.gw_type
  gw_id = aws_nat_gateway.natgw[v.gw].id } if v.gw_type == "natgw" })

}

module "tgw_subnets" {
  for_each    = var.tgw_attachments
  source      = "./modules/tgw_subnets"
  tgw_subnets = each.value.tgw_subnets
  vpc_id      = aws_vpc.custom_vpc.id
  name-prefix = local.name-prefix
}

resource "aws_ec2_transit_gateway_vpc_attachment" "custom_vpc" {
  for_each           = var.tgw_attachments
  vpc_id             = aws_vpc.custom_vpc.id
  transit_gateway_id = each.value.tgw_id
  subnet_ids         = module.tgw_subnets[each.key].tgw_subnet_id
  tags = {
    Name = "${local.name-prefix}-${each.key}"
  }
}

