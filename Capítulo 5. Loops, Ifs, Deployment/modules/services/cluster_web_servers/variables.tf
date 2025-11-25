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

variable "min_size" {
    description = "Minimum number of instances in the web server cluster"
    type        = number
    default     = 2
}

variable "max_size" {
    description = "Maximum number of instances in the web server cluster"
    type        = number
    default     = 10
}

variable "custom_tags" {
    description = "A map of custom tags to apply to resources"
    type        = map(string)
    default     = {}
}

variable "enable_autoscaling" {
    description = "Enable or disable autoscaling for the web server cluster"
    type        = bool
}

variable "ami_id" {
    description = "The AMI ID to use for the web server instances"
    type        = string
    default     = "ami-0fb653ca2d3203ac1"
}

variable "server_text" {
    description = "The text to display on the web server page"
    type        = string
    default     = "Hello, World!"
}
