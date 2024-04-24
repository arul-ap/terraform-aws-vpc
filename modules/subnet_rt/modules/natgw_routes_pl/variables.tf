variable "route" {
  type = object({
    rt_id = string
    pl    = string
    natgw = string
  })
}
