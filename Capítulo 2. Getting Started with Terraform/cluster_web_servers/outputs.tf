output "alb_dns_name" {
    description = "The domain name of the load balancer"
    value       = aws_lb.lb_example.dns_name
}