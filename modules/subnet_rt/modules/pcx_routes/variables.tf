variable "route" {
  type = object({
    rt_id = string
    cidr  = string
    pcx   = string
  })
}
