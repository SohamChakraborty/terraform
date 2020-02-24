variable "instance_type" {
  type = string
}

variable "priv_ami" {
  type = string
}

variable "key_name" {
  type = string
}

variable "pub_ami" {
  type = string
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

