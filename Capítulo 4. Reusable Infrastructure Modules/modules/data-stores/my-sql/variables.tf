variable "db_username" {
  description = "The username for the MySQL database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the MySQL database"
  type        = string
  sensitive   = true
}

variable "db_prefix" {
  description = "The prefix for the MySQL database identifier"
  type        = string
}

variable "db_name" {
  description = "The name of the MySQL database"
  type        = string
}
