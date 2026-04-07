# 1. Define the AWS Provider
provider "aws" {
  region = "us-east-1" # Make sure this matches your secret AWS_REGION
}

# 2. Create a VPC (Network) for the EKS Cluster
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# 3. Create the EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-devops-cluster" # Match this to your EKS_CLUSTER_NAME secret
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Automatically grant access to the person/role creating the cluster
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    general = {
      instance_types = ["t3.medium"]
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}
