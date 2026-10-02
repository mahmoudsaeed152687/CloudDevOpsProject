output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_id" {
  value = aws_eks_cluster.main.id
}

output "node_group_name" {
  value = aws_eks_node_group.main.node_group_name
}
