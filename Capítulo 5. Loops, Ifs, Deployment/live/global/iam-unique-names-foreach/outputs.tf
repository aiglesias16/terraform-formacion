output "all_users" {
    description = "List of all IAM users created"
    value       = values(aws_iam_user.users)[*].arn
}
