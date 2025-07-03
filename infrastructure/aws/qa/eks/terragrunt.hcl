include {
  path = find_in_parent_folders("envcommon.hcl")
}

# Import VPC outputs
dependency "vpc" {
  config_path = "../network"
  mock_outputs = {
    vpc_id          = "vpc-xxxx"
    private_subnets = []
  }
}

terraform {
  # Terraform AWS EKS community module
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git//.?ref=v20.7.0"
}

inputs = {
  cluster_name    = "${local.env}-eks"
  cluster_version = "1.29"

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets           # private only

  # Managed node group (one example group)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
    desired_size   = 2
    min_size       = 1
    max_size       = 4
  }

  node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 4
      instance_types = ["t3.medium"]
    }
  }

  # Allow the LB to reach pods on 443
  cluster_security_group_additional_rules = {
    https_ingress = {
      description = "Allow HTTPS from the LB"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Optional but recommended if you’ll run the AWS LB Controller
  attach_load_balancer_controller_policy = true
  enable_irsa                            = true

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}

