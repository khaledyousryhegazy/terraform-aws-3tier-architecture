

module "metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "${var.name_prefix}-ec2-cpu-high"
  alarm_description   = "Bad errors in ${var.name_prefix}-logs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 70
  period              = 60

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_actions = [var.topic_arn]
}

module "log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = "${var.name_prefix}-log-group"
  retention_in_days = 120
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.name_prefix}-cloudwatch-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      #   AWS/EC2 - CPUUtilization
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "AutoScalingGroupName",
              var.asg_name
            ]
          ]
          stat   = "Average"
          period = 300
          region = var.region
          title  = "EC2 Instance CPU"
        }
      },
      #   CWAgent - mem_used_percent
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "CWAgent",
              "mem_used_percent",
              "AutoScalingGroupName",
              var.asg_name
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.region

          title = "EC2 Memory Usage"
        }
      },
      #   CWAgent - disk_used_percent
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "CWAgent",
              "used_percent",
              "path",
              "/",
              "AutoScalingGroupName",
              var.asg_name
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.region

          title = "Disk Usage"
        }
      },
      #   AWS/ApplicationELB - RequestCount
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]

          stat   = "Sum"
          period = 300
          region = var.region

          title = "ALB Request Count"
        }
      },
      #   AWS/RDS - CPUUtilization
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              var.db_identifier
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.region

          title = "RDS CPU Utilization"
        }
      },
      #   AWS/RDS - FreeStorageSpace
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/RDS",
              "FreeStorageSpace",
              "DBInstanceIdentifier",
              var.db_identifier
            ]
          ]

          stat   = "Average"
          period = 300
          region = var.region

          title = "RDS Free Storage"
        }
      }
    ]
  })
}
