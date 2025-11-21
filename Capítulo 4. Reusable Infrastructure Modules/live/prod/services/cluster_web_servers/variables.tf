variable "cluster_name" {
    description = "The name of the web server cluster"
    type        = string
    default     = "prod-webserver-cluster"
}


variable "db_remote_state_bucket" {
    description = "The S3 bucket where the remote state of the database is stored"
    type        = string
}

variable "db_remote_state_key" {
    description = "The S3 key where the remote state of the database is stored"
    type        = string
}

