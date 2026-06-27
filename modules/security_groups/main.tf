# ALB security group
module "alb_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "${var.name_prefix}-alb-sg"
  description = "security group for ALB"
  vpc_id      = var.vpc_id

  ingress_rules = {
    http-from-vpc = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }

    https-from-vpc = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

# APP security group (source -> ALB SG)
module "app_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "${var.name_prefix}-app-sg"
  description = "security group for app allowing traffic from alb"
  vpc_id      = var.vpc_id

  ingress_rules = {
    http-from-alb = {
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb_sg.id
    }

    ssh-to-app = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

# DB security group (source -> APP SG)
module "db_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "${var.name_prefix}-db-sg"
  description = "security group for db allowing traffic from app"
  vpc_id      = var.vpc_id

  ingress_rules = {
    db-from-app = {
      from_port                    = 5432
      to_port                      = 5432
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.app_sg.id
    }
  }
}

