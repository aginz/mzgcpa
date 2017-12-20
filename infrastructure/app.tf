# Grabs AWS ubuntu image
data "aws_ami" "base_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Config for autoscale group
resource "aws_launch_configuration" "mzgcpa_launch_config" {
  name          = "mzgcpa"
  image_id      = "${data.aws_ami.base_image.id}"
  instance_type = "t2.micro"
}

# Autoscale servers
resource "aws_autoscaling_group" "mzgcpa_autoscaling_group" {
  availability_zones        = ["us-east-1a"]
  name                      = "mzgcpa"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.mzgcpa_launch_config.name}"
}

# Create a new load balancer
resource "aws_elb" "mzgcpa_elb" {
  name               = "mzgcpa"
  availability_zones = ["us-east-1a"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }
}

