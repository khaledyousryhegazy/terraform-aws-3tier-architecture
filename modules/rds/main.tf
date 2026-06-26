module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier           = "${var.name_prefix}-postgres"
  engine               = "postgres"
  engine_version       = "17"
  family               = "postgres17"
  major_engine_version = "17"

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name                     = "app"
  username                    = var.db_username
  manage_master_user_password = true # aws SM

  port                   = 5432
  vpc_security_group_ids = [var.db_sg_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval    = "30"
  monitoring_role_name   = "${var.name_prefix}-rds-monitoring-role"
  create_monitoring_role = true

  tags = {
    Environment = var.environment
    Project     = var.name_prefix
  }

  create_db_subnet_group = true
  subnet_ids             = var.database_subnets

  deletion_protection          = true
  storage_encrypted            = true
  performance_insights_enabled = true
  multi_az                     = true

  backup_retention_period = 7
}
