provider "aws" {
  region = "us-east-2"
}


data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter{
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

data "terraform_remote_state" "db" {
    backend = "s3"

    config = {
        bucket = "terraform-state-bucket-aiglesias16"
        key    = "stage/data-stores/mysql/terraform.tfstate"
        region = "us-east-2"
    }
}

resource "aws_lb" "lb_example"{
    name = "terraform-asg-lb-example"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.lb_example.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type = "fixed-response"
        fixed_response {
          content_type = "text/plain"
          message_body = "404: Not Found"
          status_code  = "404"
        }
    }
}

resource "aws_security_group" "alb_sg" {
    name = "load-balancer-sg"
    description = "Allow HTTP inbound traffic to load balancer and outgoing requests to perform healts checks"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }   
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_target_group" "alb_target_group"{
    name = "terraform-asg-targets"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
    }
}


resource "aws_launch_template" "example" {
    name_prefix   = "terraform-asg-example-"
    image_id      = "ami-0fb653ca2d3203ac1"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.web_server_sg.id]
    
    user_data = templatefile("user_data.sh", { 
        server_port = var.server_port 
        db_address = var.terraform_remote_state.db.db_address
        db_port = var.terraform_remote_state.db.db_port
    })

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
        vpc_zone_identifier = data.aws_subnets.default.ids

        target_group_arns = [aws_lb_target_group.alb_target_group.arn]
        health_check_type = "ELB"

        min_size = 2
        max_size = 10

        launch_template {
            id      = aws_launch_template.example.id
            version = "$Latest"
        }

        tag {
            key                   = "Name"
            value                 = "terraform-asg-example"
            propagate_at_launch   = true
        }
}

resource "aws_lb_listener_rule" "asg_listener_rule" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
        path_pattern {
          values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_target_group.arn
    }
}

resource "aws_security_group" "web_server_sg" {
    name        = "web-server-sg"
    description = "Allow HTTP inbound traffic"

    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}