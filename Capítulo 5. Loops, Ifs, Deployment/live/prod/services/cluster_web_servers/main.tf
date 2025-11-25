terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-aiglesias16"
    key            = "services/cluster_web_servers/prod/terraform.tfstate"
    region         = "us-east-2"
 
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
  }
}

provider "aws" {
    region = "us-east-2"

    ## Tags to apply to all resources
    default_tags {
        tags = {
            Owner       = "aiglesias16"
            ManagedBy     = "Terraform"
        }
    }
}

module "webserver_cluster" {
    source = "../../../../modules/services/cluster_web_servers"
    cluster_name = var.cluster_name
    db_remote_state_bucket = var.db_remote_state_bucket
    db_remote_state_key = var.db_remote_state_key

    custom_tags = {
        Owner = "aiglesias16"
        ManagedBy       = "Terraform"
    }
    enable_autoscaling = true
}



resource "aws_security_group_rule" "prod_testing" {
    type = "ingress"
    security_group_id = module.webserver_cluster.alb_security_group_id
    
    from_port = 12345
    to_port = 12345
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
