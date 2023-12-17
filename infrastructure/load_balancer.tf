#  Create target group for jenkins load balancer
resource "aws_lb_target_group" "jenkins-alb-target-group" {
  name       = var.target_group_name  
  port       = 8080
  protocol   = "HTTP"
  vpc_id     = aws_vpc.jenkins-vpc.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 8081
    interval            = 30
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

#  Attach the target group to jennkins server. Jenkins listens on port 8080
resource "aws_lb_target_group_attachment" "jenkins-alb-attachment" {
  target_group_arn = aws_lb_target_group.jenkins-alb-target-group.arn
  target_id        = aws_instance.jenkins-server.id
  port             = 8080
}

#  Create application load balancer for jenkins
resource "aws_lb" "jenkins-alb" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenkins-alb-sg.id]

  subnets = [
    aws_subnet.jenkins-bastion.id,   // Place the load balancer in the 2 public subnets
    aws_subnet.jenkins-public.id  
  ]
}

#  Listener for HTTP
resource "aws_lb_listener" "jenkins-alb-listener" {
  load_balancer_arn = aws_lb.jenkins-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-alb-target-group.arn
  }
}

#  Listener for HTTPS. Useful if you create certificate
resource "aws_lb_listener" "jenkins-alb-listener-2" {
  load_balancer_arn = aws_lb.jenkins-alb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-alb-target-group.arn
  }
}

# resource "aws_lb_listener" "jenkins-alb-listener-3" {
#   load_balancer_arn = aws_lb.jenkins-alb.arn
#   port              = "9418"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.jenkins-alb-target-group.arn
#   }
# }