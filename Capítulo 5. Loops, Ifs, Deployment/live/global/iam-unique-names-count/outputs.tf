output "first_arn" {
    description = "The ARN for the first user"
    value = aws_iam_user.example[0].arn
}

output "all_arns" {
    description = "The ARN for the first user"
    value = aws_iam_user.example[*].arn
}