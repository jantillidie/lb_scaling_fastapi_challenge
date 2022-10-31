resource "aws_launch_template" "template" {
  name = "launch-template-terraform"

  credit_specification {
    cpu_credits = "standard"
  }

  image_id = "ami-08e2d37b6a0129927"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  key_name = "vockey"

  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  user_data = filebase64("userdata.sh")

  tags = {
    "Name" = "fastapiec2"
  }
}

resource "aws_autoscaling_group" "autoscalewebserver" {
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.autoscalewebserver.id
  lb_target_group_arn    = aws_lb_target_group.webserver_target.arn
}
