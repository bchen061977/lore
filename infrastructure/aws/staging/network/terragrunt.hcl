include {
  path = find_in_parent_folders("envcommon.hcl")
}

terraform {
  # Terraform AWS VPC community module
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//.?ref=v5.5.0"
}

inputs = {
  name = "${local.env}-vpc"
  cidr = local.cidr

  # 2 public + 2 private subnets
  public_subnets  = [for idx, _ in local.azs : cidrsubnet(local.cidr, 8, idx)]
  private_subnets = [for idx, _ in local.azs : cidrsubnet(local.cidr, 8, idx + 10)]
  azs             = local.azs

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Networking extras
  enable_nat_gateway = true   # two NAT GWs (one per AZ)
  single_nat_gateway = false
  
  # ADD THESE ↓ — the cluster name comes from envcommon.hcl
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
  
}
