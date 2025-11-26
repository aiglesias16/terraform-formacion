variable "allowed_repos_branches" {
  description = "GitHub repos/branches allowed to assume the IAM role."
  type = list(object({
    org    = string
    repo   = string
    branch = string
  }))
}

variable "name" {
  description = "Name used to namespace all the resources in this module."
  type        = string
  default     = "github-oidc-example"
}

