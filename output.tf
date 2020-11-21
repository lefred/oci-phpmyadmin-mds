output "phpmyadmin_public_ip" {
  value = module.phpmyadmin.public_ip
}

output "mds_instance_ip" {
  value = module.mds-instance.private_ip
}
