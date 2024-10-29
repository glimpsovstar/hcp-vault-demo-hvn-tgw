variable "region" {
  type = string
  default = "ap-southeast-2"
}

variable "Name" {
  type = string
}

variable "owner" {
  type = string
}

variable "TTL" {
  type = number
  default = 24
}
variable "hvn_cidr" {
  type = string
  default = "172.25.16.0/20"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.18.0/24"
}

variable "az" {
  type = string 
  default = "ap-southeast-2a"
}