terraform {
    backend "s3" {
        
        bucket = "terraform-state-bucket-aiglesias16"
        key = "global/s3/terraform.tfstate"
        region = "us-east-2"
        
        dynamodb_table = "terraform-state-lock-table"
        encrypt = true
    }
}

provider "aws" {
    region = "us-east-2"
}

resource "aws_db_instance" "my_sql_db" {
    identifier_prefix    = "terraform-mysql-db-example"
    engine               = "mysql"
    allocated_storage    = 10
    
    instance_class       = "db.t3.micro"
    skip_final_snapshot  = true
    db_name              = "mydatabase"    
    
    username             = var.db_username
    password             = var.db_password

    tags = {
      Name = "terraform-mysql-db-example"
    }
}