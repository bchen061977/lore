remote_state {
  backend = "gcs"
  generate = { path = "backend.tf", if_exists = "overwrite" }
  config   = {
    bucket = "my‑terragrunt‑state‑gcp"
    prefix = "${path_relative_to_include()}"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "google"      { project = "my‑gcp‑project" region = "us‑west2" }
provider "google-beta" { project = "my‑gcp‑project" region = "us‑west2" }
EOF
}
