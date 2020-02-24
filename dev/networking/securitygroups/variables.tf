variable "ingress_cidr_blocks" {
  type	= list(string)
}

variable "cidr_blocks" {
  type = string
}

#variable "vpc_id" {
#  type = string
#}

variable "Environment" {
}

variable "Purpose" {
}

variable "Role" {
}

variable "default_tags" {
  type = map
  default = {
    Terraform-managed 	= "true"
    Billingcenter	= "ops"
  }
}

