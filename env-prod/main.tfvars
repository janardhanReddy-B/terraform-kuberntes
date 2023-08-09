env = "prod"

## Default VPC Information
default_vpc_id          = "vpc-033afb10db1e6a9da"
default_vpc_cidr_block  = "172.31.0.0/16"
default_vpc_route_table = "rtb-0ba2f25e4527ec7d1"
workstation_ip          = "172.31.94.211/32"
allow_ssh_cidr          = ["172.31.94.211/32"]
allow_monitor_cidr      = ["172.31.13.150/32"]

## KMS Information
kms_key_id   = "arn:aws:kms:us-east-1:637261222008:key/2eeb6c9c-36f5-4e89-857c-680ad8eedf3e"
acm_cert_arn = "arn:aws:acm:us-east-1:637261222008:certificate/3a62dc5f-d69c-4a22-a843-a6186fc9dc6b"


## Route53 Info
domain = "devopsbjr.online"

## VPC

vpc = {
  prod = {
    vpc_cidr_block           = "10.50.0.0/16"
    public_subnet_cidr_block = ["10.50.0.0/24", "10.50.1.0/24"]
    app_subnet_cidr_block    = ["10.50.2.0/24", "10.50.3.0/24"]
    db_subnet_cidr_block     = ["10.50.4.0/24", "10.50.5.0/24"]
    subnet_azs               = ["us-east-1a", "us-east-1b"]
  }
}

docdb = {
  prod = {
    engine                  = "docdb"
    backup_retention_period = 1
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    storage_encrypted       = true
    instance_count          = 1
    instance_class          = "db.t3.medium"
  }
}

rds = {
  prod = {
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.11.0"
    dbname                  = "dummy"
    skip_final_snapshot     = true
    backup_retention_period = 1
    preferred_backup_window = "07:00-09:00"
    storage_encrypted       = true
    instance_count          = 1
    instance_class          = "db.t3.medium"
  }
}

elasticache = {
  prod = {
    engine          = "redis"
    engine_version  = "6.x"
    num_cache_nodes = 1
    node_type       = "cache.t3.medium"
    az_mode         = "single-az"
  }
}

rabbitmq = {
  prod = {
    instance_type = "t3.small"
    component = "rabbitmq"
  }
}

