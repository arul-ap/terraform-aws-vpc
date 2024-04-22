variable "vpc_id" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "name-prefix" {
  type = string
}

variable "sg" {
  type = object({
    description = string
    ingress_rules = map(object({
      protocol         = number
      source_cidr      = optional(string, null)
      sg               = optional(string, null)
      pf_list          = optional(string, null)
      port_range_start = optional(number, null)
      port_range_end   = optional(number, null)
    }))
    egress_rules = map(object({
      protocol         = number
      target_cidr      = optional(string, null)
      sg               = optional(string, null)
      pf_list          = optional(string, null)
      port_range_start = optional(number, null)
      port_range_end   = optional(number, null)
    }))
    tags = map(string)
  })
}
