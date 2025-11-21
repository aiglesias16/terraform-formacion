output "s3_bucket_arn" {
    value = aws_s3_bucket.tf_state_bucket.arn
    description = "The ARN of the S3 bucket used for Terraform state storage"
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.tf_state_lock_table.name
    description = "The name of the DynamoDB table used for Terraform state locking"
}

