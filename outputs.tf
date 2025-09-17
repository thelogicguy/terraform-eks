output "vpc_id" {
  value = module.my-app-vpc.vpc_id
}
output "private_subnets" {
  value = module.my-app-vpc.private_subnets
}
output "security_group_id" {
  value = module.my-app-vpc.default_security_group_id
}