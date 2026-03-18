# ─── Web Tier Launch Template ───
resource "aws_launch_template" "web" {
  name_prefix            = "Lab-Web-LT-"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm.name
  }

  user_data = base64encode(
    replace(
      replace(
        file("${path.module}/userdata/web.sh"),
        "__STUDENT_NAME__",
        var.student_name
      ),
      "__BACKEND_URL__",
      aws_lb.internal.dns_name
    )
  )

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "Web-Tier-Instance" }
  }
}

# ─── Web Tier Auto Scaling Group ───
resource "aws_autoscaling_group" "web" {
  name                = "Lab-Web-ASG"
  desired_capacity    = 2
  min_size            = 1
  max_size            = 4
  vpc_zone_identifier = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "Web-Tier-Instance"
    propagate_at_launch = true
  }
}

# ─── Backend Tier Launch Template ───
resource "aws_launch_template" "backend" {
  name_prefix            = "Lab-Backend-LT-"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.backend.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm.name
  }

  user_data = base64encode(file("${path.module}/userdata/backend.sh"))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "Backend-Tier-Instance" }
  }
}

# ─── Backend Tier Auto Scaling Group ───
resource "aws_autoscaling_group" "backend" {
  name                = "Lab-Backend-ASG"
  desired_capacity    = 2
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  target_group_arns   = [aws_lb_target_group.backend.arn]

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 180

  tag {
    key                 = "Name"
    value               = "Backend-Tier-Instance"
    propagate_at_launch = true
  }
}

# ─── Web Tier Scaling Policy (CPU-based) ───
resource "aws_autoscaling_policy" "web_scale" {
  name                   = "Lab-Web-Scale-Policy"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

# ─── Backend Tier Scaling Policy (CPU-based) ───
resource "aws_autoscaling_policy" "backend_scale" {
  name                   = "Lab-Backend-Scale-Policy"
  autoscaling_group_name = aws_autoscaling_group.backend.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
