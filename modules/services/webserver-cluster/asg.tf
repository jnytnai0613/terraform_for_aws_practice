data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = "ap-northeast-1"
  }
}

locals {
  # 今回は問題ないが、ルートモジュール以外の別モジュールの場合は、path.moduleを指定する
  # path.module: 定義あるモジュールが存在するパスを返す
  # path.root: ルートモジュールのファイルシステムパスを返す
  # path.cwd: カレントディレクトリのパスを返す。通常はpath.rootと同じ。
  user_data_script = templatefile("${path.module}/user-data.sh", {
    server_port = var.asg_server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
    server_text = var.server_text
  })
}

# 2024年10月より起動設定(aws_launch_configuration)が新規作成できなくなっている。
resource "aws_launch_template" "example" {
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = base64encode(local.user_data_script)

  # ASGは起動設定の参照を持ってる。
  # 起動設定を変更する場合、削除→作成の流れで置き換わるので、参照を持たれると削除できない。
  # lifecycleで作成→削除の流れに変える。
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.asg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  desired_capacity = 3
  min_size         = var.min_size
  max_size         = var.max_size

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg-examle"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"

  ingress {
    from_port   = var.asg_server_port
    to_port     = var.asg_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "scale_out_during_business_hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "scale_in_at_night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.example.name
}