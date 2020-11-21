output "id" {
  value = oci_core_instance.PHPMyAdmin.id
}

output "public_ip" {
  value = oci_core_instance.PHPMyAdmin.public_ip
}

output "phpmyadmin_host_name" {
  value = oci_core_instance.PHPMyAdmin.display_name
}
