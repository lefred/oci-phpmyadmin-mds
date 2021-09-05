variable "mysql_version" {
  description = "The version of the Mysql community server."
  default     = "8.0.26"
}


variable "ssh_private_key" {
  description = "The private key to access instance. "
  default     = ""
}

variable "vm_user" {
  description = "The SSH user to connect to the master host."
  default     = "opc"
}

variable "mds_ip" {
  description = "IP of the MySQL Database Service Instance."
  default     = ""
}

variable "phpmyadmin_public_ip" {
  description = "Public IP of the PHPMyAdmin Instance."
  default     = ""
}
