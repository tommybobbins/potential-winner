variable "project_name" {
  description = "Project Name"
  default     = "potential-winner"
}

variable "host_name" {
  description = "Host Name"
  default     = "potential-winner1"
}

variable "wordpress_dbname" {
  description = "Wordpress DB Name"
  default     = "potentialwinner23"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "break_wordpress" {
  description = "Break Wordpress for a technical test"
  default     = "true"
}

variable "aws_az" {
  description = "AWS Zone"
  type        = string
  default     = "us-east-1a"
}

variable "key_name" {
  description = "Key name for potential-winner"
  type        = string
  default     = "potential-winner-key"
}

variable "rules" {
  type = list(object({
    port        = number
    proto       = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      port        = 80
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 2020
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]


}
locals {
  userdata = {
    project_name    = var.project_name,
    host_name       = var.host_name,
    mysql_user      = var.project_name,
    mysql_db        = var.wordpress_dbname,
    mysql_pass      = random_password.mysql_string.result,
    break_wordpress = var.break_wordpress
  }
}
