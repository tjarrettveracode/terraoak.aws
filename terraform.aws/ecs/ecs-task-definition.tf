resource "aws_ecs_task_definition" "sac_ecs_task_definition" {
  
  family                   = "sac-ecs-task-def"
  container_definitions = jsonencode([{
      "memory": 32,
      "essential": true,
      "entryPoint": [
        "ping"
      ],
      "name": "alpine_ping",
      "readonlyRootFilesystem": true,
      "image": "alpine:3.4",
      "command": [
        "-c",
        "4",
        "google.com"
      ],
      "cpu": 16
  }])

  cpu                      = 1024
  memory                   = 2048
  network_mode             = "none"

  volume {  
    name = "myEfsVolume"
    efs_volume_configuration {
      file_system_id= aws_efs_file_system.sac_ecs_efs.id
      transit_encryption= "DISABLED"
      
      authorization_config {
          iam ="DISABLED"
      }
    }
  }
}

resource "aws_efs_file_system" "sac_ecs_efs" {
  creation_token = "efs-html"

  tags = {
      Environment="dev"
    }
}