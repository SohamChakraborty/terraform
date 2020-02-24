terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "terraform-soham-poc"
    key    = "dev/ec2/terraform.tfstate"
    profile = "soham-pythian-sandbox"
  }
}

provider "aws" {
  region = "us-west-2"
  profile = "soham-pythian-sandbox"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    key     = "dev/vpc/terraform.tfstate"
    region  = "us-west-2"
    bucket  = "terraform-soham-poc"
    profile = "soham-pythian-sandbox"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    key     = "dev/securitygroup/terraform.tfstate"
    region  = "us-west-2"
    bucket  = "terraform-soham-poc"
    profile = "soham-pythian-sandbox"
  }
}

module "private-instance" {
  source			= "../../../terraform-modules/terraform-aws-ec2-instance/"
  name				= "dockerhost"
  instance_count		= 3
  key_name			= var.key_name
  instance_type			= var.instance_type
  ami				= var.priv_ami
  vpc_security_group_ids	= [data.terraform_remote_state.security.outputs.private_security_group_id]
  subnet_ids			= data.terraform_remote_state.vpc.outputs.private_subnets
  tags = "${merge(var.default_tags,map("Environment",var.Environment,"Purpose",var.Purpose,"Role",var.Role,"Outside","no"))}"
}

module "public-instance" {
   source			= "../../../terraform-modules/terraform-aws-ec2-instance/"
   name				= "jumphost"
   instance_count		= 1
   key_name			= var.key_name
   instance_type		= var.instance_type
   ami				= var.pub_ami
   vpc_security_group_ids	= [data.terraform_remote_state.security.outputs.internet_facing_security_group_id]
   subnet_ids			= data.terraform_remote_state.vpc.outputs.public_subnets
  tags = "${merge(var.default_tags,map("Environment",var.Environment,"Purpose",var.Purpose,"Role",var.Role))}"
}
