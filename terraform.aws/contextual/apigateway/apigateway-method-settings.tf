resource "aws_api_gateway_method_settings" "sac_api_gateway_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.sac_api_gateway_rest_api.id
  stage_name  = aws_api_gateway_stage.sac_api_gateway_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
    caching_enabled = true
    cache_data_encrypted = true
  }
}