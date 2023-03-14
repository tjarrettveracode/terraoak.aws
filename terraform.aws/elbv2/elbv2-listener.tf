resource "aws_lb_listener" "elbv2_listener" {
  load_balancer_arn = aws_lb.elbv2_sac.arn  
  port = 99

  protocol = "HTTP"

  default_action {  
    type = "forward"  
    target_group_arn = aws_lb_target_group.elbv2_target_group.arn   

    authenticate_oidc {
      on_unauthenticated_request = "allow"
      session_cookie_name        = "sac-testing-cookie"
      session_timeout            = 300
      client_id                  = ""   
      client_secret              = ""   
      issuer                     = "https://oak9.okta.com/oauth2/default"   
      token_endpoint             = "https://oak9.okta.com/oauth2/default/v1/token"  
      authorization_endpoint     = "https://oak9.okta.com/oauth2/default/v1/authorize"  
      user_info_endpoint         = "https://oak9.okta.com/oauth2/default/v1/userinfo"   
    }
  }
}