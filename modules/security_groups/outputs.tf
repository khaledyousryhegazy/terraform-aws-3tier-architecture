output "app_sg_id" {
  description = "App security group IDS"
  value       = module.app_sg.id
}

output "db_sg_id" {
  description = "RDS Database IDS"
  value       = module.db_sg.id
}

output "alb_sg_id" {
  description = "ALB security group IDS"
  value       = module.app_sg.id
}
