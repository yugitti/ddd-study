module "cicd" {
  source = "./modules"

  // from local variables
  project                     = var.project
  environment                 = var.environment
  region                      = var.region
  account_id                  = var.account_id
  source_code_repository_name = var.source_code_repository_name
  source_code_branch          = var.source_code_branch

  // from remote state
  container_name   = data.terraform_remote_state.microservice.outputs.container_name
  ecr_repo_name    = data.terraform_remote_state.microservice.outputs.ecr_repo_name
  ecs_cluster_name = data.terraform_remote_state.microservice.outputs.ecs_cluster_name
  ecs_service_name = data.terraform_remote_state.microservice.outputs.ecs_service_name


}