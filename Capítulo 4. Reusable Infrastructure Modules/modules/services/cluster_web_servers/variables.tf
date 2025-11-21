variable "server_port" {
    description = "The port on which the web server will listen"
    type        = number
    default     = 8080
}

variable "cluster_name" {
    description = "The name of the web server cluster"
    type        = string
}

variable "db_remote_state_bucket" {
    description = "The S3 bucket name where the database remote state is stored"
    type        = string
}

variable "db_remote_state_key" {
    description = "The S3 key (path) where the database remote state is stored"
    type        = string
}