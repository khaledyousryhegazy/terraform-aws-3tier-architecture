# VPC outputs
# VPC_ID
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

# Private subnet
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = zipmap(module.vpc.azs, module.vpc.private_subnets)
}

# Public subnet
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = zipmap(module.vpc.azs, module.vpc.public_subnets)
}

# Database subnet
output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = zipmap(module.vpc.azs, module.vpc.database_subnets)
}

# NAT public IPS
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

####################################################
# VPC endpoints

output "s3_endpoint_id" {
  value = module.vpc_endpoints.vpc_endpoints.s3.id
}
