variable "org" {
  description = "Organization code to inlcude in resource names"
  type = string
}
variable "proj" {
  description = "Project code to include in resource names"
  type = string
}
variable "env" {
  description = "Environment code to include in resource names"
  type = string
}
variable "vpc_name" {
  description = "VPC name"
  type = string
  default = "vpc-01"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type = string
  default = "172.31.0.0/16"
}
variable "vpc_tags" {
  description = "Tags for VPC"
  type = map(string)
  default = {
    Description = "Terraform Default"
  }
}
variable "public_subnets" {
    description = "map of public subnets"
    type = map(object({
        subnet_cidr = string
        az = string
        tags = map(string)
    }))
    default = {}
}

variable "private_subnets" {
    description = "map of public subnets"
    type = map(object({
        subnet_cidr = string
        az = string
        tags = map(string)
    }))
    default = {
      "private-subnet1" = {
        subnet_cidr = "172.31.10.0/24"
        az = "a"
        tags = {
            Description = "Terraform default"
        }
      }
      "private-subnet2" = {
        subnet_cidr = "172.31.11.0/24"
        az = "b"
        tags = {
            Description = "Terraform default"
        }
      }
    }
}
variable "natgw" {
  description = "NAT GW details"
  type = map(object({
    type = optional(string,"public")
    subnet = string
    tags = map(string)
  }))
  default = {}
}

variable "default_nacl_ingress" {
  type = map(object({
    protocol = number
    source = string
    port_range_start = number
    port_range_end = number
    action = string
  }))
  default = {
    "100" = {
      protocol = -1
      source = "0.0.0.0/0"
      port_range_start = 0
      port_range_end = 0
      action = "allow"
    }
  }
}

variable "default_nacl_egress" {
  type = map(object({
    protocol = number
    target = string
    port_range_start = number
    port_range_end = number
    action = string
  }))
  default = {
    "100" = {
      protocol = -1
      target = "0.0.0.0/0"
      port_range_start = 0
      port_range_end = 0
      action = "allow"
    }
  }
}

variable "nacl" {
    type = map(object({
        private_subnets = optional(list(string),[])
        public_subnets = optional(list(string),[])
        ingress = map(object({
            protocol = number
            source = string
            port_range_start = number
            port_range_end = number
            action = string
        }))
        egress = map(object({
            protocol = number
            target = string
            port_range_start = number
            port_range_end = number
            action = string
        }))
    }))
    default = {}
}
variable "default_sg_ingress" {
  type = map(object({
    protocol = number
    source_cidr = optional(string,null)
    sg = optional(string,null)
    pf_list = optional(string,null)
    port_range_start = optional(number,null)
    port_range_end = optional(number,null)
  }))
  default = { 
    Default_inbound = {
      protocol = -1
      sg = "self"
      } 
  }
}
variable "default_sg_egress" {
  type = map(object({
    protocol = number
    target_cidr = optional(string,null)
    sg = optional(string,null)
    pf_list = optional(string,null)
    port_range_start = optional(number,null)
    port_range_end = optional(number,null)
  }))
  default = {
    Default_outbound = {
      protocol = -1
      target_cidr = "0.0.0.0/0"
    }
  }
}
variable "sg" {
  type = map(object({
    description = string
    ingress_rules = map(object({
        protocol = number
        source_cidr = optional(string,null)
        sg = optional(string,null)
        pf_list = optional(string,null)
        port_range_start = optional(number,null)
        port_range_end = optional(number,null)
    }))
    egress_rules = map(object({
        protocol = number
        target_cidr = optional(string,null)
        sg = optional(string,null)
        pf_list = optional(string,null)
        port_range_start = optional(number,null)
        port_range_end = optional(number,null)
    }))
    tags = map(string)
  }))
  default = {}
}
variable "rt" {
  type = map(object({
    public_subnets = optional(list(string),[])
    private_subnets = optional(list(string),[])
    routes = map(object({
      destination_cidr = string
      gw_type = string
      gw = string
    }))
    tags = optional(map(string))
  }))
  default = { }
}


variable "tgw_attachments" {
  type = map(object({
    tgw_id = string
    tgw_subnets = map(object({
        subnet_cidr = string
        az = string
    }))
  }))
  default = {}
}
