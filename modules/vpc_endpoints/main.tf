module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = var.vpc_id

  create_security_group      = true
  security_group_name_prefix = "${var.name_prefix}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"

  security_group_rules = {
    ingress_https = {
      description = "HTTPS from app instances"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_blocks = [var.vpc_cidr]
    }
  }
}

resource "aws_vpc_endpoint" "ssm_endpoints" {
  for_each = toset(["ssm", "ssmmessages", "ec2messages"])

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.private_subnets
  security_group_ids  = [module.vpc_endpoints.security_group_id]

  tags = {
    Name = "${var.name_prefix}-${each.value}-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids

  tags = {
    Name = "${var.name_prefix}-s3-endpoint"
  }
}
