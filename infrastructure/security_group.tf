# Security Group for Jenkins server
resource "aws_security_group" "jenkins-sg" {
  vpc_id      = aws_vpc.jenkins-vpc.id
  name        = "jenkins-sg"
  description = "security group for jenkins server"
}
#  Port to receive traffic from Load balancer
resource "aws_security_group_rule" "jenkins-alb-ingress" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins-sg.id
  source_security_group_id = aws_security_group.jenkins-alb-sg.id
}
#  Port to receive traffic from loaad balancer health check
resource "aws_security_group_rule" "jenkins-alb-health-check" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins-sg.id
  source_security_group_id = aws_security_group.jenkins-alb-sg.id
}
#  Port to receive traffic from the bastion host
resource "aws_security_group_rule" "jenkins-bastion-ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins-sg.id
  source_security_group_id = aws_security_group.bastion-sg.id
}
#  All outbound traffic on all ports
resource "aws_security_group_rule" "jenkins-full-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.jenkins-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
#  Security Group for application load balancer
resource "aws_security_group" "jenkins-alb-sg" {
  vpc_id      = aws_vpc.jenkins-vpc.id
  name        = "jenkins-alb-sg"
  description = "security group for aplication load balancer"
}
#  Allow HTTP traffic from the internet
resource "aws_security_group_rule" "alb-internet-ingress-1" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins-alb-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
#  Allow HTTPS traffic from the internet
resource "aws_security_group_rule" "alb-internet-ingress-2" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins-alb-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# resource "aws_security_group_rule" "alb-github-webhook-ingress" {
#   type                     = "ingress"
#   from_port                = 9418
#   to_port                  = 9418
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.jenkins-alb-sg.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }

#  Allow outbound traffic to the jenkins server
resource "aws_security_group_rule" "alb-jenkins-egress" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins-alb-sg.id
  source_security_group_id = aws_security_group.jenkins-sg.id
}
#  Allow outbound traffic for the lb health check
resource "aws_security_group_rule" "alb-jenkins-health-check" {
  type                     = "egress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins-alb-sg.id
  source_security_group_id = aws_security_group.jenkins-sg.id
}
#  Security Group for the bastion host
resource "aws_security_group" "bastion-sg" {
  vpc_id      = aws_vpc.jenkins-vpc.id
  name        = "bastion-sg"
  description = "security group for bastion host"
}
#  Allow SSH connection from only my computer
resource "aws_security_group_rule" "bastion-ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion-sg.id
  cidr_blocks              = ["${var.My_IP}"]
}
#  Allow outbound traffic on all ports
resource "aws_security_group_rule" "bastion-full-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.bastion-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}