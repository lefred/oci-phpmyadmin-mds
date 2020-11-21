## DATASOURCE
# Init Script Files
data "template_file" "install_router" {
  template = file("${path.module}/scripts/install_router.sh")

  vars = {
    mysql_version         = var.mysql_version
    user                  = var.vm_user
    mds_ip                = var.mds_ip
  }
}

locals {
  setup_script_dest = "~/install_router.sh"
}

resource "null_resource" "TFMysqlRouter" {

  provisioner "file" {
    
    content     = data.template_file.install_router.rendered
    destination = local.setup_script_dest

    connection  {
      host        = var.phpmyadmin_public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key
    }

  }
  
  provisioner "remote-exec" {
    
    connection  {
      host        = var.phpmyadmin_public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
   
    inline = [
       "chmod +x ${local.setup_script_dest}",
       "sudo ${local.setup_script_dest}"
    ]
  }
}
