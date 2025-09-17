# VPC Configuration Variables
variable "vpc_cidr_block" {}
variable "private_subnets_cidr_blocks" {}
variable "public_subnets_cidr_blocks" {}
variable "environment" {}

# VPC endpoint Configuration Variables
variable "vpc_endpoints" {
  description = "Map of VPC endpoints with configuration"
  type = map(object({
    service            = string
    vpc_endpoint_type  = string            # "Interface" or "Gateway"
    subnet_ids         = optional(list(string), [])
    security_group_ids = optional(list(string), [])
    route_table_ids    = optional(list(string), []) # needed for Gateway endpoints
  }))

  default = {
    ec2 = {
      service            = "ec2"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = []
      security_group_ids = []
    }
    ecr_api = {
      service            = "ecr.api"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = []
      security_group_ids = []
    }
    ecr_dkr = {
      service            = "ecr.dkr"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = []
      security_group_ids = []
    }
    s3 = {
      service            = "s3"
      vpc_endpoint_type  = "Gateway"
      route_table_ids    = []
    }
    dynamodb = {
      service            = "dynamodb"
      vpc_endpoint_type  = "Gateway"
      route_table_ids    = []
    }
  }
}


