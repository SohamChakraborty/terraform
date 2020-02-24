output "public_instance_ip" {
  description 	= "Public IP of the public instance"
  value		= module.public-instance.public_ip
}

output "private_instance_ip" {
  description	= "Private IP of the private instance"
  value		= module.private-instance.private_ip
}

output "instance_id" {
  description  	= "instance id"
  value		= module.public-instance.id
}
