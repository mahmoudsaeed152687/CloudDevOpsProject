variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zone_1" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_2" {
  type    = string
  default = "us-east-1b"
}
