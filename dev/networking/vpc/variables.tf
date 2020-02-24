variable "cidr" {
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "default_tags" {
  type = map
  default = {
    Terraform-managed 	= "true"
    Billingcenter	= "ops"
  }
}

variable "Name" {
}

variable "Environment" {
}

variable "Purpose" {
}

variable "Role" {
}
