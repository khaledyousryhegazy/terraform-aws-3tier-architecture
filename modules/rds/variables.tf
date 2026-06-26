variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_sg_id" {
  type = string
}

variable "database_subnets" {
  type = list(string)
}
