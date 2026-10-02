output "frontend_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "auth_service_repository_url" {
  value = aws_ecr_repository.auth_service.repository_url
}

output "roadmap_service_repository_url" {
  value = aws_ecr_repository.roadmap_service.repository_url
}
