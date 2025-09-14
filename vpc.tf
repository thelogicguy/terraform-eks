provider "aws" {
  region = "us-east-1"
}

variable "vpc_cidr_block" {}
variable "private_subnets_cidr_blocks" {}
variable "public_subnets_cidr_blocks" {}

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


    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true

    tags = {
        "kubernertes.io/cluster/myapp-eks-cluster" = "shared" 
    }

    public_subnet_tags = {
        "kubernertes.io/cluster/myapp-eks-cluster" = "shared" 
        "kubernetes.io/role/elb" = "1"
    }

    private_subnet_tags = {
        "kubernertes.io/cluster/myapp-eks-cluster" = "shared" 
        "kubernetes.io/role/internal-elb" = "1"
    }
}

