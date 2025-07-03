locals {
  # Two AZs ⇒ two NAT GWs, two subnet pairs
  azs = ["us-west-2a", "us-west-2b"]

  # One /16 block per environment
  env_cidrs = {
    dev     = "10.0.0.0/16"
    qa      = "10.1.0.0/16"
    staging = "10.2.0.0/16"
    prod    = "10.3.0.0/16"
  }

  # Derive env name from folder path (dev, qa, …)
  env = basename(get_parent_terragrunt_dir())
}

inputs = {
  azs  = local.azs
  cidr = local.env_cidrs[local.env]
  env  = local.env
}

