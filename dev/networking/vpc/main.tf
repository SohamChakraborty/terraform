terraform {
  backend "s3" {
    region = "us-west-2"
    bucket = "terraform-soham-poc"
    key    = "dev/vpc/terraform.tfstate"
    profile = "soham-pythian-sandbox"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    key		= "dev/ec2/terraform.tfstate"
    region	= "us-west-2"
    bucket	= "terraform-soham-poc"
    profile	= "soham-pythian-sandbox"
  }
}

provider "aws" {
  region = "us-west-2"
  profile = "soham-pythian-sandbox"
}

module "vpc" {
  source = "../../../../terraform-modules/terraform-aws-vpc/"

  name = "${var.Environment}-${var.Role}-${var.Purpose}"
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_ipv6 = false

  # We don't want NAT gateway here. In production scenarios, we may. But for now to save cost, we will use a bastion server/jump host that will have connectivity with the public Internet.
  enable_nat_gateway = false
  single_nat_gateway = false

  tags = "${merge(var.default_tags,map("Environment",var.Environment,"Purpose",var.Purpose,"Role",var.Role))}"

}
