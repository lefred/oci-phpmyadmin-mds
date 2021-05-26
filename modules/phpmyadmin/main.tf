## DATASOURCE
# Init Script Files
data "template_file" "install_php" {
  template = file("${path.module}/scripts/install_php74.sh")

  vars = {
    mysql_version         = var.mysql_version,
    user                  = var.vm_user
  }
}

data "template_file" "install_phpmyadmin" {
  template = file("${path.module}/scripts/install_phpmyadmin.sh")

  vars = {
    phpMyAdmin_version    = var.phpMyAdmin_version
    mds_ip                = var.mds_ip
  }
}

data "template_file" "configure_local_security" {
  template = file("${path.module}/scripts/configure_local_security.sh")
}

locals {
  php_script      = "~/install_php74.sh"
  phpmyadmin_script       = "~/install_phpmyadmin.sh"
  security_script = "~/configure_local_security.sh"
}

resource "oci_core_instance" "PHPMyAdmin" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}${var.display_name}"
  shape               = var.shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus = var.flex_shape_ocpus
    }
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "${var.label_prefix}${var.display_name}"
    assign_public_ip = var.assign_public_ip
    hostname_label   = var.display_name
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  provisioner "file" {
    content     = data.template_file.install_php.rendered
    destination = local.php_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.install_phpmyadmin.rendered
    destination = local.phpmyadmin_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.configure_local_security.rendered
    destination = local.security_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

   provisioner "remote-exec" {
    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
   
    inline = [
       "chmod +x ${local.php_script}",
       "sudo ${local.php_script}",
       "chmod +x ${local.phpmyadmin_script}",
       "sudo ${local.phpmyadmin_script}",
       "chmod +x ${local.security_script}",
       "sudo ${local.security_script}"
    ]

   }

  timeouts {
    create = "10m"

  }
}
