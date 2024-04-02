locals {
  vpc_id                      = data.terraform_remote_state.network.outputs.vpc_id
  subnet_public_ids           = data.terraform_remote_state.network.outputs.subnet_public_ids
  subnet_private_ids          = data.terraform_remote_state.network.outputs.subnet_private_ids
  security_group_ecs_ids      = data.terraform_remote_state.network.outputs.security_group_ecs_ids
  security_group_alb_ids      = data.terraform_remote_state.network.outputs.security_group_alb_ids
  ecs_task_role_arn           = data.terraform_remote_state.network.outputs.iam_role_ecs_task_arn
  ecs_task_execution_role_arn = data.terraform_remote_state.network.outputs.iam_role_ecs_task_execution_arn

  remote_rest_api_id = data.terraform_remote_state.network.outputs.rest_api_id
  remote_parent_id   = data.terraform_remote_state.network.outputs.parent_id
}
