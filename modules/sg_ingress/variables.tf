
variable "sg_id" {
  type = string
}

variable "name-prefix" {
  type = string
}

variable "ingress_rules" {
  type = map(object({
    protocol         = number
    source_cidr      = optional(string, null)
    sg_id            = optional(string, null)
    pf_list_id       = optional(string, null)
    port_range_start = optional(number, null)
    port_range_end   = optional(number, null)
  }))
}
