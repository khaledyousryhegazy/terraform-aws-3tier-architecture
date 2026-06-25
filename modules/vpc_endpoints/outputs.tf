output "vpc_endpoints" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = module.vpc_endpoints.endpoints
}

output "vpc_endpoints_security_group_id" {
  description = "ID of the security group"
  value       = module.vpc_endpoints.security_group_id
}
