terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "terraform-soham-poc"
    key    = "dev/securitygroup/terraform.tfstate"
    profile = "soham-pythian-sandbox"
  }
}

provider "aws" {
  version = "~> 2.43"
  region = "us-west-2"
  profile = "soham-pythian-sandbox"
}

data "terraform_remote_state" "route_table" {
  backend = "s3"
  config = {
    key     = "dev/route_table/terraform.tfstate"
    region  = "us-west-2"
    bucket  = "terraform-soham-poc"
    profile = "soham-pythian-sandbox"
  }
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

module "sg_ssh" {
  source 	= "../../../../terraform-modules/terraform-aws-security-group/"
  name 		= "ssh-security-group-from-internet"
  description	= "Security group so that users can login to the instance from their work computer"
  vpc_id	= data.terraform_remote_state.vpc.outputs.vpc_id
  ingress_cidr_blocks 	= var.ingress_cidr_blocks
  ingress_with_cidr_blocks	= [
    {
      from_port		= 22
      to_port		= 22
      protocol		= "tcp"
      cidr_blocks	= var.cidr_blocks
    }
  ]
  egress_with_cidr_blocks	= [
    {
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = var.cidr_blocks
    },
    {
      from_port		= 80
      to_port		= 80
      protocol		= "tcp"
      cidr_blocks	= "0.0.0.0/0"
    }
  ]

  tags = "${merge(var.default_tags,map("Environment",var.Environment,"Purpose",var.Purpose,"Role",var.Role))}"
}

module "sg_private" {
  source			= "../../../../terraform-modules/terraform-aws-security-group/"
  name				= "ssh-security-group-from-aws"
  description			= "Security group so that users can login to the instances from AWS VPC"
  vpc_id			= data.terraform_remote_state.vpc.outputs.vpc_id
  computed_ingress_with_source_security_group_id	= [
    {
      rule			= "ssh-tcp"
      source_security_group_id	= "${module.sg_ssh.this_security_group_id}"
    }
  ]
  egress_with_source_security_group_id			= [
    {
      rule			= "http-80-tcp"
      source_security_group_id	= data.terraform_remote_state.route_table.outputs.nat_sg_id
    },
    {
      rule			= "https-443-tcp"
      source_security_group_id	= data.terraform_remote_state.route_table.outputs.nat_sg_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id	= 1
  
  ingress_with_self 					= [
    {
      from_port			= "2377"
      to_port			= "2377"
      protocol			= "tcp"
      description		= "swarm ingress"
      self			= true
    }
  ]

  tags = "${merge(var.default_tags,map("Environment",var.Environment,"Purpose",var.Purpose,"Role",var.Role))}"
}
