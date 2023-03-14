resource "aws_ecs_cluster" "ecs_cluster" {
  name = "myapp-cluster"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "testapp-task"
  execution_role_arn       = "execution_role"
  task_role_arn            = "task_role"
  network_mode             = "bridge"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = "${file("${path.module}/templates/image/image.json")}"

  volume {  
      name = "myEfsVolume"
            efs_volume_configuration {
                file_system_id= aws_efs_file_system.efs.id
                root_directory= "/"
                transit_encryption= "DISABLED"
                transit_encryption_port= 2999
            }
    }
}


resource "aws_efs_file_system" "ecs_efs_system" {
  creation_token = "efs-html"

  tags = {
      Name = "test-app"
      Environment="dev"
      CreatedBy=""
    }
}


resource "aws_ecs_service" "ecs_service" {

  name            = "testapp-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = "enabled"
  }

  iam_role = ""
  depends_on = [aws_alb_listener.testapp, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_task_set" "ecs_task_set" {
  service         = aws_ecs_service.ecs_service.id
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.id

  network_configuration {
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }
}