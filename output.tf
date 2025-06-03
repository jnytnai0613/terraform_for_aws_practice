output "public_ip" {
  value = aws_instance.example.public_ip
  depends_on = [aws_security_group.instance]
  description = "The public ip address of the web server"
}