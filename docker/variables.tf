variable "docker_host" {
  type    = string
}

variable "docker_admin" {
  type    = string
}

variable "db_password" {
  description = "The password for the MySQL and Ghost database"
  type        = string
  sensitive   = true # This hides the value from terminal logs
}

variable "mailgun_password" {
  description = "The API password for Mailgun"
  type        = string
  sensitive   = true
}

variable "mailgun_user" {
  type        = string
}

variable "ghost_url" {
  type    = string
  default = "https://blog.cv-laboratories.com"
}

variable "ghost_volume" {
  type    = string
}

variable "ghostdb_volume" {
  type    = string
}

variable "gitea_volume" {
  type    = string
}