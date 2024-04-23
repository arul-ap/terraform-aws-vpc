
data "aws_region" "current" {}

resource "aws_subnet" "tgw_subnets" {
  for_each          = var.tgw_subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value.subnet_cidr
  availability_zone = "${data.aws_region.current.name}${each.value.az}"
  tags = merge(each.value.tags, {
    Name = "${var.name-prefix}-${each.key}"
  })
}
