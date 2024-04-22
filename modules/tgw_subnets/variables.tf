
variable "tgw_subnets" {
  type = map(object({
    subnet_cidr = string
    az          = string
  }))
}
variable "vpc_id" {
  type = string
}
