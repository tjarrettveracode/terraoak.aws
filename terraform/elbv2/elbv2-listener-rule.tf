resource "aws_lb_listener_rule" "elbv2-listener-rule" {
  listener_arn = aws_lb_listener.elbv2_listener.arn  # Required

  action {
    type = "forward"  # Required
    target_group_arn = aws_lb_target_group.elbv2_target_group.arn   # Required
  
    authenticate_oidc {
      on_unauthenticated_request = "allow"
      session_cookie_name        = "sac-testing-cookie"
      session_timeout            = 300
      client_id                  = "0oajirplq0DdSQFs5695"   # Required
      client_secret              = "5gaTr1CLnT_O5j7gUVLdJJ0fkkYddHpxe88dqueV"   # Required
      issuer                     = "https://oak9.okta.com/oauth2/default"   # Required
      token_endpoint             = "https://oak9.okta.com/oauth2/default/v1/token"  # Required
      authorization_endpoint     = "https://oak9.okta.com/oauth2/default/v1/authorize"  # Required
      user_info_endpoint         = "https://oak9.okta.com/oauth2/default/v1/userinfo"   # Required
    }
  }

  condition {
    host_header {
      values = ["example.com"]
    }
  }
}