module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${var.name_prefix}-alb"
  vpc_id  = var.vpc_id
  subnets = var.public_subnets

  security_groups = [var.alb_sg_id]

  enable_deletion_protection = false

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "app"
      }
    }
  }

  target_groups = {
    app = {
      name_prefix = "${var.target_group_name}-"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"

      create_attachment = false

      deregistration_delay              = 10
      load_balancing_algorithm_type     = "round_robin"
      load_balancing_anomaly_mitigation = "off"
      load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 1
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled  = true
        path     = "/"
        port     = "traffic-port"
        protocol = "HTTP"
      }
    }
  }
}
