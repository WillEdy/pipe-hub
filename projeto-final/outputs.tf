output "cluster_name" {
  description = "Nome do cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nome do serviço"
  value       = aws_ecs_service.web.name
}

output "ecs_task_definition" {
  description = "Definição da task"
  value       = aws_ecs_task_definition.nginx.arn
}

output "load_balancer_dns" {
  description = "Nome do DNS no LoadBalancer"
  value       = aws_lb.ecs_alb.dns_name
}