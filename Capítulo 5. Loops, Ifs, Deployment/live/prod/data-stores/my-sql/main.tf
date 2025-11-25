terraform {
    backend "s3" {
        
        bucket = "terraform-state-bucket-aiglesias16"
        key = "data-stores/my-sql/prod/terraform.tfstate"
        region = "us-east-2"
        
        dynamodb_table = "terraform-state-lock-table"
        encrypt = true
    }
}

provider "aws" {
    region = "us-east-2"
}

module "db_instance" {
    source = "../../../modules/data-stores/my-sql"
    db_prefix = "prod-"
    db_name = "prod_database"
    db_username = var.db_username
    db_password = var.db_password
}