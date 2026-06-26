# VPC module
module "vpc" {
  source      = "../../modules/vpc"
  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr
  azs         = local.azs
  tags        = local.tags
}

# VPC endpoints module
module "vpc_endpoints" {
  source          = "../../modules/vpc_endpoints"
  vpc_id          = module.vpc.vpc_id
  vpc_cidr        = var.vpc_cidr
  name_prefix     = local.name_prefix
  private_subnets = module.vpc.private_subnets
  db_sg_id        = module.security_groups.db_sg_id
}

# Security groups module
module "security_groups" {
  source      = "../../modules/security_groups"
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr
  name_prefix = local.name_prefix
}

# IAM module
module "iam" {
  source      = "../../modules/iam"
  name_prefix = local.name_prefix
  tags        = local.tags
}

# ASG module
module "autoscaling_group" {
  source                = "../../modules/auto_scaling_group"
  name_prefix           = local.name_prefix
  environment           = local.Environment
  image_ami             = local.latest_ami
  private_subnets       = module.vpc.private_subnets
  instance_type         = var.instance_type
  app_sg_id             = module.security_groups.app_sg_id
  instance_profile_name = module.iam.instance_profile_name
}

# ALB module
module "alb" {
  source         = "../../modules/alb"
  vpc_id         = module.vpc.vpc_id
  alb_sg_id      = module.security_groups.alb_sg_id
  name_prefix    = local.name_prefix
  public_subnets = module.vpc.public_subnets
}

# RDS module (postgres)
module "rds" {
  source = "../../modules/rds"

  db_sg_id         = module.security_groups.db_sg_id
  name_prefix      = local.name_prefix
  database_subnets = module.vpc.database_subnets
  environment      = local.Environment
  db_username      = var.db_username
}
