variable "name_prefix" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "image_ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_sg_id" {}
