# live/gcp/dev/networking/terragrunt.hcl
include "env" { path = find_in_parent_folders("envcommon.hcl") }

terraform {
  source = "tfr://registry.terraform.io/terraform-google-modules/network/google"
}

inputs = {
  project_id   = "my‑gcp‑project"
  network_name = local.vpc_name

  subnets = [
    {
      subnet_name   = "public-${local.environment}"
      subnet_ip     = "10.${local.env_index}.0.0/19"
      subnet_region = local.region
    },
    {
      subnet_name           = "private-${local.environment}"
      subnet_ip             = "10.${local.env_index}.128.0/19"
      subnet_region         = local.region
      subnet_private_access = true
    },
  ]

  routers = {
    "router-${local.environment}" = {
      region = local.region
      nats   = { nat‑a = {}, nat‑b = {} }   # 2 Cloud NAT configs
    }
  }
}

