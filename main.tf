#module "s3_bucket" {
# source = "./modules/s3_bucket"
#bucket = "dmi_example"
#acl    = "private"
#}

#terraform {
# backend "s3" {
#  bucket         = "september1111"
# key            = "mm/mm.tfstate"
#region         = "us-east-1"
#dynamodb_table = "mytabledmi"
#}
#}

#module "dynamodb_table" {
# source = "terraform-aws-modules/dynamodb-table/aws"

#name     = "mytabledmi"
#hash_key = "lockID"

#attributes = [
#  {
#   name = "id"
#  type = "N"
#}
#]
#}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "dmimy-cluster"
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
  control_plane_subnet_ids = module.vpc.intra_subnets

  #vpc_id     = "vpc-0b5d6b149be1dc4f2"
  #subnet_ids = ["subnet-0d672b3db5dc0d5ff", "subnet-0c285a2080ee1ecb7"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t2.micro"]

    use_custom_launch_template = false
    disk_size                  = 8
  }

  eks_managed_node_groups = {
    dmi1 = {}
    dmi2 = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
    }
  }

  cluster_encryption_config = {}

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
