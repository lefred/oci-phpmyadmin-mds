output "phpmyadmin_public_ip" {
  value = "${module.phpmyadmin.public_ip}"
}

output "mds_instance_ip" {
  value = "${module.mds-instance.private_ip}"
}

output "instance_ssh_keys" {
  value       = tls_private_key.public_private_key_pair.private_key_pem
  description = "Please copy and save the private key to ssh in compute instance"
  sensitive    = true
}
