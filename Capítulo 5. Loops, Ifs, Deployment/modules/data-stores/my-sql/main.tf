resource "aws_db_instance" "my_sql_db" {
    identifier_prefix    = var.db_prefix
    engine               = "mysql"
    allocated_storage    = 10
    
    instance_class       = "db.t3.micro"
    skip_final_snapshot  = true
    db_name              = var.db_name    
    
    username             = var.db_username
    password             = var.db_password

    tags = {
      Name = "${var.db_prefix}mysql-db"
    }
}