
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_public_ids" {
  value = [for value in aws_subnet.public_subnet : value.id]
}

output "subnet_private_ids" {
  value = [for value in aws_subnet.private_subnet : value.id]
}

output "security_group_ecs_ids" {
  value = aws_security_group.ecs_sg.id
}

output "security_group_alb_ids" {
  value = aws_security_group.alb_sg.id

}

output "iam_role_ecs_task_arn" {
  value = aws_iam_role.ecs_task.arn
}

output "iam_role_ecs_task_execution_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

# rest_api_idのエクスポート
output "rest_api_id" {
  value = aws_api_gateway_rest_api.apigw.id
}

# parent_idのエクスポート（通常、ルートリソースIDとして参照される）
output "parent_id" {
  value = aws_api_gateway_rest_api.apigw.root_resource_id
}