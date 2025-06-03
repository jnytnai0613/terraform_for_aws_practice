provider "aws" {
  region = "ap-northeast-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_launch_configuration" "example" {
  image_id                    = "ami-026c39f4021df9abe"
  instance_type          = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p ${var.asg_server_port} &
              EOF
  
  # ASGは起動設定の参照を持ってる。
  # 起動設定を変更する場合、削除→作成の流れで置き換わるので、参照を持たれると削除できない。
  # lifecycleで作成→削除の流れに変える。
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnets.default.ids

  target_group_arns = aws_lb_target_group.asg.arn
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key = "Name"
    value = "terraform-asg-examle"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.asg_server_port
    to_port     = var.asg_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}