output "adress" {
    value = aws_db_instance.my_sql_db.address
    description = "Connect to the database at this address"
}

output "port" {
    value = aws_db_instance.my_sql_db.port
    description = "Connect to the database at this port"
}

