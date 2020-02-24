output "internet_facing_security_group_id" {
  description = "Internet facing security group"
  value       = module.sg_ssh.this_security_group_id
}

output "vpc_id_internet_facing_sg" {
  description = "The VPC ID"
  value       = module.sg_ssh.this_security_group_vpc_id
}

output "internet_facing_security_group_owner_id" {
  description = "The owner ID"
  value       = module.sg_ssh.this_security_group_owner_id
}

output "internet_facing_security_group_name" {
  description = "The name of the internet facing security group"
  value       = module.sg_ssh.this_security_group_name
}

output "internet_facing_security_group_description" {
  description = "The description of the internet facing security group"
  value       = module.sg_ssh.this_security_group_description
}

output "private_security_group_id" {
  description = "private security group"
  value       = module.sg_private.this_security_group_id
}

output "vpc_id_private_sg" {
  description = "The VPC ID associated with private SG"
  value       = module.sg_private.this_security_group_vpc_id
}

output "private_security_group_owner_id" {
  description = "The owner ID"
  value       = module.sg_private.this_security_group_owner_id
}

output "private_security_group_name" {
  description = "The name of the private security group"
  value       = module.sg_private.this_security_group_name
}

output "private_security_group_description" {
  description = "The description of the private security group"
  value       = module.sg_private.this_security_group_description
}


