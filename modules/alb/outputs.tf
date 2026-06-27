output "target_group_arn" {
  value = module.alb.target_groups["app"].arn
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "alb_arn_suffix" {
  value = module.alb.arn_suffix
}
