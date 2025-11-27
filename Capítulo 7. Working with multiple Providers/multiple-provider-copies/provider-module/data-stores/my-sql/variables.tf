variable "db_name" {
  description = "The name of the MySQL database"
  type        = string
  default     = null
}

variable "db_username" {
  description = "The username for the MySQL database"
  type        = string
  sensitive   = true
  default = null
}

variable "db_password" {
  description = "The password for the MySQL database"
  type        = string
  sensitive   = true
  default     = null
}

variable "backup_retention_period" {
    description = "The number of days to retain backups for the database"
    type        = number
    default     = null
}

variable "replicate_source_db" {
    description = "The source database instance identifier for replication"
    type        = string
    default     = null
}