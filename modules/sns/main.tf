module "sns_topic" {
  source = "terraform-aws-modules/sns/aws"

  name = "${var.name_prefix}-sns"

  subscriptions = {
    email = {
      protocol = "email"
      endpoint = "yousryk49@gmail.com"
    }
  }

  tags = {
    Environment = var.environment
    Project     = "${var.name_prefix}"
  }
}

# ASG Notification Resource
resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [var.asg_id]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = module.sns_topic.topic_arn
}
