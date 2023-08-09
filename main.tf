module "vpc" {
  source                  = "git::https://github.com/janardhanReddy-B/tf-module-vpc-k.git"
  env                     = var.env
  default_vpc_id          = var.default_vpc_id
  default_vpc_cidr_block  = var.default_vpc_cidr_block
  default_vpc_route_table = var.default_vpc_route_table
  workstation_ip          = var.workstation_ip

  for_each                 = var.vpc
  vpc_cidr_block           = each.value.vpc_cidr_block
  public_subnet_cidr_block = each.value.public_subnet_cidr_block
  app_subnet_cidr_block    = each.value.app_subnet_cidr_block
  db_subnet_cidr_block     = each.value.db_subnet_cidr_block
  subnet_azs               = each.value.subnet_azs
}

module "docdb" {
  source     = "git::https://github.com/janardhanReddy-B/tf-module-docdb-k.git"
  env        = var.env
  kms_key_id = var.kms_key_id

  for_each                = var.docdb
  engine                  = each.value.engine
  backup_retention_period = each.value.backup_retention_period
  preferred_backup_window = each.value.preferred_backup_window
  skip_final_snapshot     = each.value.skip_final_snapshot
  storage_encrypted       = each.value.storage_encrypted
  instance_count          = each.value.instance_count
  instance_class          = each.value.instance_class

  vpc = module.vpc
}

module "rds" {
  source     = "git::https://github.com/janardhanReddy-B/tf-module-rds-k.git"
  env        = var.env
  kms_key_id = var.kms_key_id

  for_each                = var.rds
  engine                  = each.value.engine
  backup_retention_period = each.value.backup_retention_period
  preferred_backup_window = each.value.preferred_backup_window
  skip_final_snapshot     = each.value.skip_final_snapshot
  storage_encrypted       = each.value.storage_encrypted
  engine_version          = each.value.engine_version
  dbname                  = each.value.dbname
  instance_count          = each.value.instance_count
  instance_class          = each.value.instance_class

  vpc = module.vpc
}


module "elasticache" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-ealsticache-k.git"
  env    = var.env

  for_each        = var.elasticache
  engine          = each.value.engine
  engine_version  = each.value.engine_version
  num_cache_nodes = each.value.num_cache_nodes
  node_type       = each.value.node_type
  az_mode         = each.value.az_mode

  vpc = module.vpc
}


module "rabbitmq" {
  source = "git::https://github.com/janardhanReddy-B/tf-module-rabbitmq-k.git"
  env    = var.env
  domain = var.domain

  for_each      = var.rabbitmq
  instance_type = each.value.instance_type

  vpc = module.vpc
}



module "eks" {
  source                  = "git::https://github.com/janardhanReddy-B/tf-module-vpc-b.git"
  ENV                     = var.env
  PRIVATE_SUBNET_IDS      = lookup(lookup(module.vpc, var.env, null), "app_subnets_ids", null)
  PUBLIC_SUBNET_IDS       = lookup(lookup(module.vpc, var.env, null), "public_subnets_ids", null)
  DESIRED_SIZE            = 2
  MAX_SIZE                = 2
  MIN_SIZE                = 2
  CREATE_EXTERNAL_SECRETS = true
  INSTALL_KUBE_METRICS    = true
}
