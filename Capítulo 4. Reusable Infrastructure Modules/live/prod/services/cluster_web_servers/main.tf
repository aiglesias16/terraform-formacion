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
}

module "webserver_cluster" {
    source = "../../../modules/services/cluster_web_servers"
    cluster_name = var.cluster_name
    db_remote_state_bucket = "terraform-state-bucket-aiglesias16"
    db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
}

resource "aws_autoscaling_schedule" "scale_out_during_bussiness_hours" {
    scheduled_action_name = "scale-out-during-business-hours"
    min_size                  = 2
    max_size                  = 10
    desired_capacity          = 10
    recurrence                =  "0 9 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_int_at_night" {
    scheduled_action_name = "scale-in-at-night"
    min_size                  = 2
    max_size                  = 10
    desired_capacity          = 2
    recurrence                =  "0 17 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
  
}

resource "aws_security_group_rule" "prod_testing" {
    type = "ingress"
    security_group_id = module.webserver_cluster.alb_security_group_id
    
    from_port = 12345
    to_port = 12345
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}