variable "route" {
  type = object({
    rt_id = string
    pl    = string
    tgw   = string
  })
}
