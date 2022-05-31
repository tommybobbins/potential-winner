resource "random_password" "mysql_string" {
  length  = 16
  special = false
  #  override_special = "/@£$"
}

