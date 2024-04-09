output "container_name"{
    value = var.container_name
}

output "ecr_repo_name"{
  value = module.ecs.ecr_repo_name
}

output "ecs_cluster_name"{
  value = module.ecs.ecs_cluster_name
}

output "ecs_service_name"{
  value = module.ecs.ecs_service_name
}