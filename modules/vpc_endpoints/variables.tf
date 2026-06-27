variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {}

variable "db_sg_id" {
  type = string
}

variable "private_route_table_ids" {

}

variable "region" {
  type = string
}
