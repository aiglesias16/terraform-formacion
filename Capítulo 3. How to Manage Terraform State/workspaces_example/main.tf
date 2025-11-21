terraform {
    backend "s3" {
        bucket = "terraform-state-bucket-aiglesias16"
        key = "workspaces_example/terraform.tfstate"
        region = "us-east-2"
        dynamodb_table = "terraform-state-lock-table"
        encrypt = true
    }
}   

provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "name" {
    ami           = "ami-0fb653ca2d3203ac1"
    instance_type = terraform.workspace == "production" ? "t3.medium" : "t3.micro"

    tags = {
      Name = "terraform-workspaces-example"
    }
}