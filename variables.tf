variable "org" {
  description = "Organization code to inlcude in resource names"
  type        = string
}
variable "proj" {
  description = "Project code to include in resource names"
  type        = string
}
variable "env" {
  description = "Environment code to include in resource names"
  type        = string
}
variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}
variable "vpc_tags" {
  description = "Tags for VPC"
  type        = map(string)
  default     = {}
}
variable "public_subnets" {
  description = "Map of public subnets"
  type = map(object({
    subnet_cidr = string
    az          = string
    tags        = map(string)
  }))
  default = {}
}

variable "private_subnets" {
  description = "Map of public subnets"
  type = map(object({
    subnet_cidr = string
    az          = string
    tags        = map(string)
  }))
  default = {}
}
variable "natgw" {
  description = "NAT Gateway details"
  type = map(object({
    type   = optional(string, "public")
    subnet = string
    tags   = map(string)
  }))
  default = {}
}

variable "default_nacl_ingress" {
  description = "Ingress rules for default NACL. Use rule number as key"
  type = map(object({
    protocol         = number
    source           = string
    port_range_start = number
    port_range_end   = number
    action           = string
  }))
  default = { //Import default NACL ingress rule.
    "100" = {
      protocol         = -1
      source           = "0.0.0.0/0"
      port_range_start = 0
      port_range_end   = 0
      action           = "allow"
    }
  }
}

variable "default_nacl_egress" {
  description = "Egress rules for default NACL. Use rule number as key"
  type = map(object({
    protocol         = number
    target           = string
    port_range_start = number
    port_range_end   = number
    action           = string
  }))
  default = { //Import default NACL egress rule.
    "100" = {
      protocol         = -1
      target           = "0.0.0.0/0"
      port_range_start = 0
      port_range_end   = 0
      action           = "allow"
    }
  }
}

variable "nacl" {
  description = "Map of custom NACL with both ingress and egress rules."
  type = map(object({
    private_subnets = optional(list(string), [])
    public_subnets  = optional(list(string), [])
    ingress = map(object({
      protocol         = number
      source           = string
      port_range_start = number
      port_range_end   = number
      action           = string
    }))
    egress = map(object({
      protocol         = number
      target           = string
      port_range_start = number
      port_range_end   = number
      action           = string
    }))
  }))
  default = {}
}
variable "default_sg_ingress" {
  description = "Ingress rules for default security group"
  type = map(object({
    protocol         = number
    source_cidr      = optional(string, null)
    sg               = optional(string, null)
    pf_list          = optional(string, null)
    port_range_start = optional(number, null)
    port_range_end   = optional(number, null)
  }))
  default = { // Import default security group ingress rules.
    Default_inbound = {
      protocol = -1
      sg       = "self"
    }
  }
}
variable "default_sg_egress" {
  description = "Egress rules for default security group"
  type = map(object({
    protocol         = number
    target_cidr      = optional(string, null)
    sg               = optional(string, null)
    pf_list          = optional(string, null)
    port_range_start = optional(number, null)
    port_range_end   = optional(number, null)
  }))
  default = { // Import default security group egress rules.
    Default_outbound = {
      protocol    = -1
      target_cidr = "0.0.0.0/0"
    }
  }
}
variable "sg" {
  description = "Map of custom security groups with ingress and egress rules."
  type = map(object({
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
  }))
  default = {}
}
variable "rt" {
  description = "Map of custom route tables"
  type = map(object({
    public_subnets  = optional(list(string), [])
    private_subnets = optional(list(string), [])
    routes = map(object({
      destination_cidr = optional(string)
      is_prefix_list   = optional(bool, false)
      prefix_list_id   = optional(string)
      gw_type          = string
      gw               = string
    }))
    tags = optional(map(string))
  }))
  default = {}
}


variable "tgw_attachments" {
  description = "Map of transit gateway attachements from this VPC"
  type = map(object({
    tgw_id = string
    tgw_subnets = map(object({
      subnet_cidr = string
      az          = string
      tags        = map(string)
    }))
  }))
  default = {}
}
