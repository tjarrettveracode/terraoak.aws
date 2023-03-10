resource "aws_dynamodb_table" "dynamo-db-" {
  name           = "foo"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "GameTitle"
  read_capacity  = 1
  write_capacity = 1

  tags = {
    Name        = "dynamodb-table-1"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }


  point_in_time_recovery {
    # DEMO - severity change based on business impact Low -> High
    enabled = false
  }
  
  timeouts {
    create = "10m"
    delete = "10m"
    update = "1h"
  }
  global_secondary_index {
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    write_capacity     = 2
    read_capacity      = 2
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"]
  }

  server_side_encryption {
    enabled     = false
    # DEMO - violation based on data sensitivity
    #kms_key_arn = ""
    
  }
}


resource "aws_kms_key" "foo_DDB" {
  description             = "This key is used to encrypt dynamoDB objects"
  deletion_window_in_days = 10
  enable_key_rotation = true
  key_usage = "ENCRYPT_DECRYPT"
  tags = {
    Name        = "kms-key-1"
  }
}