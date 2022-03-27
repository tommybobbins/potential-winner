resource "random_password" "mysql_string" {
  length           = 16
  special          = false
#  override_special = "/@£$"
}


data "template_file" "init" {
  template = file("userdata.sh")
  vars = {
    project_name = var.project_name,
    bucket_name  = var.bucket_name,
    host_name    = var.host_name,
    mysql_user   = var.project_name,
    mysql_db     = var.wordpress_dbname,
    mysql_pass   =  random_password.mysql_string.result
  }
}

