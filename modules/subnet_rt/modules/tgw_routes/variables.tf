variable "route" {
  type = object({
    rt_id = string
    cidr  = string
    tgw   = string
  })
}
