Purpose:
Terraform code to provision a single VPC with:
 - Public subnets
 - Private subnets
 - Internet Gateway if there is any public subnets.
 - NAT Gateways. Public NAT Gateway with Elastic IP.
 - NACL:
    - Import Default NACL into terraform code.
    - Create Custom NACLs and attach to subnets.
 - Security Groups:
    - Import Default Security Group into terraform code.
    - Custom Security Groups.
 - Route Tables:
    - Create Custom route tables and associate with subnets.
 - Attach VPC to Transit gateway

