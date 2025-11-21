terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-aiglesias16"
    key            = "services/cluster_web_servers/stage/terraform.tfstate"
    region         = "us-east-2"
 
    dynamodb_table = "terraform-state-lock-table"
    encrypt        = true
  }
}

provider "aws" {
    region = "us-east-2"
}

module "webserver_cluster" {
    source = "../../../modules/services/cluster_web_servers"
    cluster_name = "stage-webserver-cluster"
    db_remote_state_bucket = "terraform-state-bucket-aiglesias16"
    db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"
}

