terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "terraform-soham-poc"
    key    = "dev/route_table/terraform.tfstate"
    profile = "soham-pythian-sandbox"
  }
}

provider "aws" {
  version = "~> 2.43"
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

module "nat" { 
  source	= "/home/soham/Documents/learn/terraform/terraform-modules/terraform-aws-nat-instance"
  
  name		= "main"
  vpc_id	= data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet	= data.terraform_remote_state.vpc.outputs.public_subnets[0]
  private_subnets_cidr_blocks	= data.terraform_remote_state.vpc.outputs.private_subnets_cidr_blocks
  private_route_table_ids	= data.terraform_remote_state.vpc.outputs.private_route_table_ids
}
