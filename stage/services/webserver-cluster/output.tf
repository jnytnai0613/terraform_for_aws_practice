output "alb_dns_name" {
  value = aws_lb.examle.dns_name
  depends_on = [aws_security_group.instance]
  description = "The domain name of the load balancer"
}