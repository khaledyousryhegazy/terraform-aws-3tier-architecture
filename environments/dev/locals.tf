resource "random_pet" "this" {
  length = 2
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
  name_prefix = "three-tier-infra-${random_pet.this.id}"
  region      = "us-east-1"
  azs         = slice(data.aws_availability_zones.available.names, 0, 2)
  latest_ami  = data.aws_ami.amz_ami.id
  Environment = "Dev"

  tags = {
    Environment = "Dev"
    Example     = local.name_prefix
    Owner       = "Khaled"
  }
}
