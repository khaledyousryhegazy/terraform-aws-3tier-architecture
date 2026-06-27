# S3 read permissions
module "s3_policy" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  name        = "${var.name_prefix}-s3-policy"
  path        = "/"
  description = "Allow EC2 to read from S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        # like an example
        Resource = [
          "arn:aws:s3:::three-tier-infra-app-bucket-661975751370-us-east-1-an",
          "arn:aws:s3:::three-tier-infra-app-bucket-661975751370-us-east-1-an/*"
        ]
      }
    ]
  })
  tags = var.tags
}

# EC2 Role
module "ec2_iam_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"
  name   = "${var.name_prefix}-ec2-role"

  trust_policy_permissions = {
    EC2AssumeRole = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]
    }
  }

  policies = {
    s3_access = module.s3_policy.arn
    # cloudwatch managed policy
    CloudWatchAgentServerPolicy  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = var.tags
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.name_prefix}-instance-profile"
  role = module.ec2_iam_role.name

  tags = var.tags
}