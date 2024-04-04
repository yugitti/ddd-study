module "microservice" {
  source = "./modules/microservice"

  project                = var.project
  environment            = var.environment
  domain                 = var.domain
  account_id             = var.account_id
  docker_dir             = var.docker_dir
  tfstate_bucket         = var.tfstate_bucket
  tfstate_key            = var.tfstate_key
  min_capacity           = var.min_capacity
  max_capacity           = var.max_capacity
  ecs_desired_task_count = var.ecs_desired_task_count
  container_name         = var.container_name
  container_port         = var.container_port
  image_tag              = var.image_tag
  cloudwatch_log_prefix  = var.cloudwatch_log_prefix


  vpc_id                      = data.terraform_remote_state.network.outputs.vpc_id
  subnet_public_ids           = data.terraform_remote_state.network.outputs.subnet_public_ids
  subnet_private_ids          = data.terraform_remote_state.network.outputs.subnet_private_ids
  security_group_ecs_ids      = data.terraform_remote_state.network.outputs.security_group_ecs_ids
  security_group_rds_ids      = data.terraform_remote_state.network.outputs.security_group_rds_ids
  ecs_task_role_arn           = data.terraform_remote_state.network.outputs.iam_role_ecs_task_arn
  ecs_task_execution_role_arn = data.terraform_remote_state.network.outputs.iam_role_ecs_task_execution_arn

  remote_rest_api_id = data.terraform_remote_state.network.outputs.rest_api_id
  remote_parent_id   = data.terraform_remote_state.network.outputs.parent_id

  rds_database_name   = var.rds_database_name
  rds_master_username = var.rds_master_username
  rds_port            = var.rds_port
  rds_engine          = var.rds_engine
  rds_engine_version  = var.rds_engine_version
}
