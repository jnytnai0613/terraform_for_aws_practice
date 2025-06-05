module "webserver-cluster" {
  source                 = "../../../modules/services/webserver-cluster"
  cluster_name           = "webserver-stage"
  db_remote_state_bucket = "terraform-up-and-running-state-taniai"
  db_remote_state_key    = "stage/data-store/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 4
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver-cluster.alb_security_group_id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}