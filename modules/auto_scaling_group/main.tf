module "autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"
  name   = "${var.name_prefix}-autoscaling-group"

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  health_check_type   = "ELB"
  vpc_zone_identifier = var.private_subnets

  instance_refresh = {
    strategy = "Rolling"

    preferences = {
      checkpoint_delay       = 600           # between every check point wait 600s then continue
      checkpoint_percentages = [35, 70, 100] # stop to checking before continue
      instance_warmup        = 300           # wait after running new version to check if it's working
      min_healthy_percentage = 50            # not be available on fewer than two working servers.
      max_healthy_percentage = 100           # don't create more than max_size
    }
  }

  # =========================
  #   launch template========
  # =========================

  launch_template_name        = "${var.name_prefix}-launch-template"
  launch_template_description = "launch template for three tier app autoscaling group"
  update_default_version      = true # any change in launch template create new version

  image_id          = var.image_ami
  instance_type     = var.instance_type
  ebs_optimized     = true
  enable_monitoring = true

  iam_instance_profile_name = var.instance_profile_name

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp3"
      }
    }
  ]

  security_groups = [var.app_sg_id]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Environment = var.environment
        Project     = "${var.name_prefix}"
      }
    },
    {
      resource_type = "volume"
      tags = {
        Environment = var.environment
        Project     = "${var.name_prefix}"
      }
    }
  ]

  tags = {
    Environment = var.environment
    Project     = "${var.name_prefix}"
  }
}
