Purpose:
Terraform code to provision a single VPC with:
 - Public subnets
 - Private subnets
 - Internet Gateway if there is any public subnets.
 - NAT Gateways. Public Gateway with Elastic IP.
 - NACL:
    - Import Default NACL into terraform code.
    - Custom NACLs
 - Security Groups:
    - Import Default Security Group into terraform code.
    - Custom Security Groups.
 - Route Tables:
    - Custom subnet route tables.


