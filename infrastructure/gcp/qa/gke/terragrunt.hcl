# live/gcp/dev/gke/terragrunt.hcl
include "env" { path = find_in_parent_folders("envcommon.hcl") }

dependency "network" { config_path = "../networking" }

terraform {
  source = "tfr://registry.terraform.io/terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
}

inputs = {
  project_id = "my‑gcp‑project"
  name       = local.cluster_name
  region     = local.region

  network    = dependency.network.outputs.network_name
  subnetwork = dependency.network.outputs.subnets_names[1]  # private subnet

  ip_range_pods     = "10.${local.env_index}.240.0/21"
  ip_range_services = "10.${local.env_index}.248.0/22"

  enable_private_nodes = true
  node_pools = [
    { name = "default", machine_type = "e2-medium", min_count = 2, max_count = 4 }
  ]
}

