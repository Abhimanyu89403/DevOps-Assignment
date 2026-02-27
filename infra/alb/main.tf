resource "aws_lb" "pgagi_lb" {
    name = "PGAGI_load_balancer"
    internal = false
    load_balancer_type = "Application"
    subnets = []
    security_groups = []
}

resource "aws_lb_target_group" "pgagi_fe_target_group" {
    name = "FE-TG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.pgagi_vpc.id
    target_type = "ip"

    health_check {
        path = "/health"
        matcher = "200"
        interval = 30
    }
}

resource "aws_lb_target_group" "pgagi_be_target_group" {
    name = "BE-TG"
    port = 3000
    protocol = "HTTP"
    vpc_id = aws_vpc.pgagi_vpc.id

    health_check {
       path = "/"
       matcher = "200"
       interval = 30
    }
}

resource "aws_lb_target_listener" "pgagi_listener" {
    load_balancer_arn = aws_lb.pgagi_lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.pgagi_fe_target_group.arn
    }
}

resource "aws_lb_listener_rule_arn" "api_rule" {
    listener_arn = aws_lb_target_listener.pgagi_listener.arn
    priority = 10

    action {
        type = "Forward"
        target_group_arn = aws_lb_target_group.pgagi_be_target_group.arn
    }

    condition {
        path_pattern {
            values = ["/api/*"]
        }
    }
} 