output "iam_user_arn" {
    description = "ARN of the IAM user"
    value = aws_iam_user.example.arn
}