output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "jenkins_instance_id" {
  value = module.server.instance_id
}

output "jenkins_public_ip" {
  value = module.server.public_ip
}

output "jenkins_security_group_id" {
  value = module.server.security_group_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_node_group_name" {
  value = module.eks.node_group_name
}

output "frontend_ecr_repository_url" {
  value = module.ecr.frontend_repository_url
}

output "auth_service_ecr_repository_url" {
  value = module.ecr.auth_service_repository_url
}

output "roadmap_service_ecr_repository_url" {
  value = module.ecr.roadmap_service_repository_url
}
