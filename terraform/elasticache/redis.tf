resource "aws_elasticache_replication_group" "elasticache_replication_group" {
  engine_version                = "6.x"
  availability_zones            = ["us-west-2a", "us-west-2b"]
  replication_group_id          = "RepGroup"
  replication_group_description = "foo-group description"
  node_type                     = var.node_type
  number_cache_clusters         = 2
  parameter_group_name          = "default.redis6.x"
  port                          = var.port
  security_group_names = [ "" ]
  security_group_ids = [ "value" ]
  
  multi_az_enabled              = false
  at_rest_encryption_enabled    = false
  auto_minor_version_upgrade    = true
  automatic_failover_enabled    = false
  transit_encryption_enabled    = false

  maintenance_window            = "sat:05:30-sat:06:30"
  snapshot_retention_limit      = 7
  snapshot_window               = "23:30-00:30"
  final_snapshot_identifier = "redis-snapshot-foo"

  timeouts {}

  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}

resource "aws_elasticache_cluster" "elasticache_cluster" {
  count = 1
  engine = "memcached"
  cluster_id           = "tf-rep-group-1-${count.index}"
  replication_group_id = "${aws_elasticache_replication_group.elasticache_replication_group.id}"
  security_group_ids = [ "cluster_security groups" ]
  security_group_names = [ "value" ]
  
}

resource "aws_elasticache_cluster" "elasticache_cluster_redis" {
  count = 1
  engine = "redis"
  snapshot_retention_limit = 5
  cluster_id           = "tf-rep-group-1-${count.index}"
  replication_group_id = "${aws_elasticache_replication_group.elasticache_replication_group.id}"
  security_group_ids = [ "cluster_security groups" ]
  security_group_names = [ "value" ]
  
}


resource "aws_elasticache_user" "elasticache_user" {
  user_id       = var.user_id
  user_name     = var.user_name
  access_string = "on ~app::* -@all +@read +@hash +@bitmap +@geo -setbit -bitfield -hset -hsetnx -hmset -hincrby -hincrbyfloat -hdel -bitop -geoadd -georadius -georadiusbymember"
  engine        = "REDIS"
  passwords     = [var.password]
}