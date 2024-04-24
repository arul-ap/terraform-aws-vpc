variable "routes" {
  type = map(object({
    cidr    = string
    pl      = string
    gw_type = string
    gw_id   = string
  }))
}
variable "rt" {
  type = object({
    vpc_id     = string
    subnet_ids = map(string)
    tags       = map(string)
  })
}