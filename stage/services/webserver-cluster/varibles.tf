variable "asg_server_port" {
  description = "The Port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "alb_ingress_port" {
  description = "The Port the load balancer will use for ingress"
  type        = number
  default     = 80
}

variable "alb_egress_port" {
  description = "The Port the load balancer will use for egress"
  type        = number
  default     = 0
}