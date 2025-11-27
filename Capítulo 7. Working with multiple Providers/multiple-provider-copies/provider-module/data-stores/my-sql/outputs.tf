output "adress" {
    value = aws_db_instance.my_sql.address
    description = "Connect to the database at this address"
}

output "port" {
    value = aws_db_instance.my_sql.port
    description = "Connect to the database at this port"
}

output "arn" {
    value = aws_db_instance.my_sql_db.arn
    description = "The ARN of the MySQL database instance"
}
