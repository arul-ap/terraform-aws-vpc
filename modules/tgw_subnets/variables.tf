
variable "tgw_subnets" {
  type = map(object({
    subnet_cidr = string
    az          = string
    tags        = map(string)
  }))
}
variable "vpc_id" {
  type = string
}

variable "name-prefix" {
  type = string
}