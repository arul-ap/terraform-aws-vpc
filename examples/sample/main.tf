terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

module "vpc" {
  source  = "arul-ap/vpc/aws"

  org = "abc"
  proj = "x"
  env = "dev"
  
  vpc_name = "vpc-01"
  vpc_cidr = "10.0.0.0/16"
  vpc_tags = {
    Description = "Test VPC 1"
  }

  public_subnets = { 
    web-subnet-01 = {
      subnet_cidr = "10.0.0.0/24"
      az = "a"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    }
    web-subnet-02 = {
      subnet_cidr = "10.0.1.0/24"
      az = "b"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    }
    web-subnet-03 = {
      subnet_cidr = "10.0.2.0/24"
      az = "c"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    } 
  } // end of public subnets

  private_subnets = {
    app-subnet-01 = {
      subnet_cidr = "10.0.10.0/24"
      az = "a"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    }
    app-subnet-02 = {
      subnet_cidr = "10.0.11.0/24"
      az = "b"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    }
    app-subnet-03 = {
      subnet_cidr = "10.0.12.0/24"
      az = "c"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    }
    db-subnet-01 = {
      subnet_cidr = "10.0.20.0/24"
      az = "a"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    }
    db-subnet-02 = {
      subnet_cidr = "10.0.21.0/24"
      az = "b"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    }
    db-subnet-03 = {
      subnet_cidr = "10.0.22.0/24"
      az = "c"
      vpc = "vpc-01"
      tags = {
        Description = "Test subnet"
      }
    }
  } // end of privatee subnets
  natgw = { 
    natgw-01 = {
      type = "public"
      subnet = "web-subnet-01"
      tags = {
        Description = "NAT GW 01"
      }
    } 
    natgw-02 = {
      type = "public"
      subnet = "web-subnet-02"
      tags = {
        Description = "NAT GW 02"
      }
    }
    natgw-03 = {
      type = "public"
      subnet = "web-subnet-03"
      tags = {
        Description = "NAT GW 03"
      }
    } 
  } // end of NAT GW
  nacl = {
    app-nacl-01 = {
      private_subnets = [ "app-subnet-01", "app-subnet-02", "app-subnet-03"]
      ingress = {
        100 = {
          protocol = -1
          source = "10.0.0.0/16"
          port_range_start = 0
          port_range_end = 0
          action = "allow"
        }
      }
      egress = {
        100 = {
          protocol = -1
          target = "10.0.0.0/16"
          port_range_start = 0
          port_range_end = 0
          action = "allow"
        }
      }
    }
  } // end NACL

  
  sg = {
    "web-sg" = {
      description = "web tier security group"
      ingress_rules = {
        HTTPS_inbound = {
          protocol = 6
          source_cidr = "0.0.0.0/0"
          port_range_start = 443
          port_range_end = 443
        } 
        HTTPS_inbound = {
          protocol = 6
          source_cidr = "0.0.0.0/0"
          port_range_start = 443
          port_range_end = 443
        } 
      }
      egress_rules ={
        Default_outbound = {
          protocol = -1
          target_cidr = "0.0.0.0/0"
        }
      }
      tags = {}
    }
  } // end security group

  
  rt = {
    "public-rt" = {
      public_subnets = ["web-subnet-01","web-subnet-02","web-subnet-03"]
      routes = {
        To_Internet = {
            destination_cidr = "0.0.0.0/0"
            gw_type = "igw"
            gw = null
        }
      }
    }
    "private-rt-az-a" = {
      private_subnets = ["app-subnet-01"]
      routes = { /*
        To_Internet = {
            destination_cidr = "0.0.0.0/0"
            gw_type = "natgw"
            gw = "natgw-01"
        } */
      }
    }
  } //end rt

/* // Attched this VPC to Transit gateway. Provision Transit gateway first. Specify tgw_id (Transit gateway ID) here and use this block of code for VPC attachment.
  tgw_attachments = {
    tgw-attach-test = {
      tgw_id = "tgw-0012345678...." // update tgw id
      tgw_subnets = {
        tgw_subnet-1 = {
          subnet_cidr = "10.0.255.0/28"
          az = "a"
        }
        tgw_subnet-2 = {
          subnet_cidr = "10.0.255.16/28"
          az = "b"
        }
        tgw_subnet-3 = {
          subnet_cidr = "10.0.255.32/28"
          az = "c"
        }
      }
    }
  }  // end of tgw attach
*/
}

