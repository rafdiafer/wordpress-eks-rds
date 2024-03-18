provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

locals {
  az_count = length(var.aws_az)
}

# VPC and subnets being defined here
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_name}-vpc"
  cidr = var.cidr_block

  azs = var.aws_az

  private_subnets = [for i in range(0, local.az_count): cidrsubnet(var.cidr_block, 8, i)]
  public_subnets  = [for i in range(local.az_count, local.az_count * length(module.vpc.private_subnets)): cidrsubnet(var.cidr_block, 8, i)]

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# EKS Cluster being defined here
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = "${var.app_name}-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id          
  subnet_ids               = module.vpc.private_subnets 
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    nodes = {
      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.min_size

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# I need the Cluster token for the Wordpress deployment
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}