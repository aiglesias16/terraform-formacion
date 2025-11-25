output "iam_user_arns" {
    description = "ARNs of the IAM users"
    value       = module.iam_users[*].iam_user_arn
}