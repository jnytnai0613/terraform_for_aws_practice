variable "name" {
  description = "The name to use for the EKS clustet"
  type        = string
}

variable "min_size" {
  description = "Minimum number of nodes to have in the EKS clustet"
  type        = number
}

variable "max_size" {
  description = "Maximum number of nodes to have in the EKS clustet"
  type        = number
}

variable "desired_size" {
  description = "Desired number of nodes to have in the EKS clustet"
  type        = number
}

variable "instance_types" {
  description = "The type of EC2 instances to run in the node group"
  type        = list(string)
}