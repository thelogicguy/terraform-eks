provider "kubernetes" {

  load_config_file       = false # We don't want to use the default kubeconfig file in ~/.kube/config
  host                   = data.aws_eks_cluster.myapp-cluster.endpoint  # EKS cluster endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.myapp-cluster.token
}

# Fetch EKS cluster details for kubernetes provider (host,and certificate)
data "aws_eks_cluster" "myapp-cluster" {
  name = module.eks.cluster_id
}

# Fetch EKS cluster authentication token
data "aws_eks_cluster_auth" "myapp-cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.2.0"

  name    = "myapp-eks-cluster"
  kubernetes_version = "1.29"

  subnet_ids      = module.my-app-vpc.private_subnets
  vpc_id          = module.my-app-vpc.vpc_id

  tags = {
    environment = "var.environment"
    application = "myapp"
  }

  cloudwatch_log_group_retention_in_days = 30

  # Enable all eks cluster logging for security monitoring
  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # Encrpt EKS secrets using KMS key
  encryption_config = {

      resources = ["secrets"]
      provider_key_arn = aws_kms_key.eks.arn
      
  }

  # Access control configuration
  # Enable private endpoint access
  endpoint_public_access = true
  endpoint_private_access = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"]

# Managed node groups configuration
  eks_managed_node_groups = {
    worker-group-1 = {
      instance_type = "t2.medium"
      asg_desired_capacity = 2
      asg_min_size = 1
      asg_max_size = 3
  
    },

    worker-group-2 = {
      instance_type = "t2.small"
      asg_desired_capacity = 1
      asg_min_size = 1
      asg_max_size = 2
      name = "worker-group-2"
    }
  }


}
    
