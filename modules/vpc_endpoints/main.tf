# module "vpc_endpoints" {
#   source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

#   vpc_id = var.vpc_id

#   create_security_group      = true
#   security_group_name_prefix = "${var.name_prefix}-vpc-endpoints-"
#   security_group_description = "VPC endpoint security group"

#   security_group_rules = {
#     ingress_https = {
#       description = "HTTPS from VPC"
#       cidr_blocks = [var.vpc_cidr]
#     }
#   }

#   endpoints = {
#     s3 = {
#       service             = "s3"
#       private_dns_enabled = true
#       dns_options = {
#         private_dns_only_for_inbound_resolver_endpoint = false
#       }
#       tags = { Name = "${var.name_prefix}-s3-vpc-endpoint" }
#     }
#     rds = {
#       service             = "rds"
#       private_dns_enabled = true
#       subnet_ids          = var.private_subnets
#       security_group_ids  = [var.db_sg_id]
#     },
#     ssm = {
#       service             = "ssm"
#       subnet_ids          = var.private_subnets
#       private_dns_enabled = true
#     },
#     ssmmessages = {
#       service             = "ssmmessages"
#       subnet_ids          = var.private_subnets
#       private_dns_enabled = true
#     },
#     ec2messages = {
#       service             = "ec2messages"
#       subnet_ids          = var.private_subnets
#       private_dns_enabled = true
#     }
#   }
# }

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = var.vpc_id

  create_security_group      = true
  security_group_name_prefix = "${var.name_prefix}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"

  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [var.vpc_cidr]
    }
  }

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = var.private_route_table_ids
      tags            = { Name = "${var.name_prefix}-s3-endpoint" }
    }

    ssm = {
      service             = "ssm"
      subnet_ids          = var.private_subnets
      private_dns_enabled = true
      security_group_ids  = [module.vpc_endpoints.security_group_id]
    }

    ssmmessages = {
      service             = "ssmmessages"
      subnet_ids          = var.private_subnets
      private_dns_enabled = true
      security_group_ids  = [module.vpc_endpoints.security_group_id]
    }

    ec2messages = {
      service             = "ec2messages"
      subnet_ids          = var.private_subnets
      private_dns_enabled = true
      security_group_ids  = [module.vpc_endpoints.security_group_id]
    }
  }
}
