provider "aws" {
  region = "us-east-1"
}

# dynamically fetch availability zones in the region
data "aws_availability_zones" "azs" {}

module "my-app-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

    name = "myapp-vpc"
    cidr = var.vpc_cidr_block
    private_subnets = var.private_subnets_cidr_blocks
    public_subnets  = var.public_subnets_cidr_blocks
    azs = data.aws_availability_zones.azs.names

    # Multi-AZ NAT Gateways for high availability
    enable_nat_gateway = true
    single_nat_gateway = false
    one_nat_gateway_per_az = true
    enable_dns_hostnames = true

    # Enhanced VPC Flow Logs configuration
    enable_flow_log                      = true
    create_flow_log_cloudwatch_log_group = true
    create_flow_log_cloudwatch_iam_role  = true
    flow_log_destination_type            = "cloud-watch-logs"
    flow_log_traffic_type               = "REJECT"  # Start with rejected traffic for cost control
    flow_log_cloudwatch_log_group_retention_in_days = 7

    # Tags for resources
    tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        environment = var.environment
        project = "myapp"
        owner = "Macdonald"
        CostCenter = "Engineering"
        ManagedBy = "Terraform"
    }

    public_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared" 
        "kubernetes.io/role/elb" = "1"
    }

    private_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared" 
        "kubernetes.io/role/internal-elb" = "1"
    }
}

