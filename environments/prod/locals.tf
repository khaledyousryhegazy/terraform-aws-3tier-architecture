resource "random_pet" "this" {
  length = 1
}

data "aws_availability_zones" "available" {}

data "aws_ami" "amz_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  name_prefix = "three-tier-infra" # can add random pet here :))
  region      = "us-east-1"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)
  latest_ami  = data.aws_ami.amz_ami.id
  Environment = "PROD"

  tags = {
    Environment = "PROD"
    Example     = local.name_prefix
    Owner       = "Khaled"
  }
}
