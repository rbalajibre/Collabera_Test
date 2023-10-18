resource "aws_lb_target_group" "collabra-alb-tg" {
  name     = "application-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "attach-app1" {
  count            = length(aws_instance.app-server)
  target_group_arn = aws_lb_target_group.collabra-alb-tg.arn
  target_id        = element(aws_instance.app-server.*.id, count.index)
  port             = 80
}
resource "aws_lb_listener" "collabr-front-end-listener" {
  load_balancer_arn = aws_lb.collabra-alb-01.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.collabra-alb-tg.arn
  }
}
resource "aws_lb" "collabra-alb-01" {
  name               = "collabra-alb-01"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg-01.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "front"
  }
}