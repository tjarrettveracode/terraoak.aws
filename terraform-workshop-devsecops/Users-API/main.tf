

output "base_url" {
  value = module.api_gateway.base_url
}

data "archive_file" "lambda_users_get" {
  type = "zip"

  source_file  = "${path.module}/_modules/python/user-get.py"
  output_path = "${path.module}/_modules/python/user-store-get.zip"
}

data "archive_file" "lambda_users_set" {
  type = "zip"

  source_file  = "${path.module}/_modules/python/user-set.py"
  output_path = "${path.module}/_modules/python/user-store-set.zip"
}

module "Lambda" {
    source = "./_modules/lambda"
    depends_on = [module.lambda_s3_bucket]
    source_code_hash_get = data.archive_file.lambda_users_get.output_base64sha256
    source_code_hash_set= data.archive_file.lambda_users_set.output_base64sha256
}

module "lambda_s3_bucket" {
    source = "./_modules/s3"
    source_getusers = data.archive_file.lambda_users_get.output_path
    etagGetUsers=filemd5(data.archive_file.lambda_users_get.output_path)
    sourcec_setusers = data.archive_file.lambda_users_set.output_path
    etagSetUsers=filemd5(data.archive_file.lambda_users_set.output_path)
}

module "dyanmodb" {
    source = "./_modules/dynamoDB"
  
}

 module "api_gateway" {
    source = "./_modules/api-gateway"
    name          = "UserApi-sandbox"
    protocol_type = "HTTP"
    description   = "Api-Gateway-UserApi-Testing"
    lambda_arn_set_user = module.Lambda.lambda_arn_UsersSet
    lambda_arn_get_user = module.Lambda.lambda_arn_UsersGet
    lambda_func_get_user_name = module.Lambda.function_name_get
    lambda_func_set_user_name =  module.Lambda.function_name_set
}
