terraform {
    backend "s3" {
        
        bucket = "terraform-state-bucket-aiglesias16"
        key = "global/s3/terraform.tfstate"
        region = "us-east-2"
        
        dynamodb_table = "terraform-state-lock-table"
        encrypt = true
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}

resource "aws_db_instance" "my_sql_db" {
    identifier_prefix    = "terraform-mysql-db-example"
    
    allocated_storage    = 10
    
    instance_class       = "db.t3.micro"
    skip_final_snapshot  = true
    
    backup_retention_period = var.backup_retention_period
    replicate_source_db     = var.replicate_source_db

    db_name              = var.replicate_source_db == null ? var.db_name : null    
    engine               = var.replicate_source_db == null ? "mysql" : null
    username             = var.replicate_source_db == null ? var.db_username : null
    password             = var.replicate_source_db == null ? var.db_password : null

    tags = {
      Name = "terraform-mysql-db-example"
    }
}