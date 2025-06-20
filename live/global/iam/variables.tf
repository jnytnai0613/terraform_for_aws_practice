variable "user_name" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "mopheus"]
}

variable "give_neo_cloudwatch_full_access" {
  description = "If true, net gets full access to CloudWatch"
  type        = bool
  default     = true
}
