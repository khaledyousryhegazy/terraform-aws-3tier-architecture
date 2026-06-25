module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr

  azs              = var.azs
  private_subnets  = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 1)]
  public_subnets   = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 11)]
  database_subnets = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 21)]

  private_subnet_names  = ["${var.name_prefix}-private-a", "${var.name_prefix}-private-b"]
  database_subnet_names = ["${var.name_prefix}-database-a", "${var.name_prefix}-database-b"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  database_subnet_tags = {
    Tier = "database"
  }
}
