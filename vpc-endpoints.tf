
module "vpc_vpc-endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "6.0.1"

    vpc_id = module.my-app-vpc.vpc_id
    subnet_ids = module.my-app-vpc.private_subnets
    security_group_ids = [module.my-app-vpc.default_security_group_id]

    endpoints = {


        ec2 ={
            service = "ec2"
            vpc_endpoint_type = "Interface"
            subnet_ids = module.my-app-vpc.private_subnets
            security_group_ids = [module.my-app-vpc.default_security_group_id]
        }

        ecr_api = {
            service = "ecr.api"
            vpc_endpoint_type = "Interface"
            subnet_ids = module.my-app-vpc.private_subnets
            security_group_ids = [module.my-app-vpc.default_security_group_id]
        }

        ecr_dkr = {
            service = "ecr.dkr"
            vpc_endpoint_type = "Interface"
            subnet_ids = module.my-app-vpc.private_subnets
            security_group_ids = [module.my-app-vpc.default_security_group_id]
        }
    }
}
