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
        bucket = var.db_remote_state_bucket
        key    = var.db_remote_state_key
        region = "us-east-2"
    }
}

resource "aws_lb" "lb_example"{
    name = var.cluster_name
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.lb_example.arn
    port              = local.http_port
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

resource "aws_security_group_rule" "allow_http_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.alb_sg.id
    
    from_port = local.http_port
    to_port = local.http_port
    protocol = local.tcp_protocol
    cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type = "egress"
    security_group_id = aws_security_group.alb_sg.id
    
    from_port = local.any_port
    to_port = local.any_port
    protocol = local.any_port_protocol
    cidr_blocks = local.all_ips
}

resource "aws_security_group" "alb_sg" {
    name = "${var.cluster_name}-alb-sg"
    description = "Allow HTTP inbound traffic to load balancer and outgoing requests to perform healts checks"
}

resource "aws_lb_target_group" "alb_target_group"{
    name = var.cluster_name
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
    
    user_data = templatefile("${path.module}/user_data.sh", { 
        server_port = var.server_port 
        db_address = var.terraform_remote_state.db.outputs.db_address
        db_port = var.terraform_remote_state.db.outputs.db_port
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
            value                 = var.cluster_name
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
    name        = "${var.cluster_name}-web-server-sg"
    description = "Allow HTTP inbound traffic"

    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }
}


locals {
    http_port = 80
    any_port = 0
    any_port_protocol = "-1"    
    tcp_protocol = "tcp"
    all_ips = ["0.0.0.0/0"]
}
