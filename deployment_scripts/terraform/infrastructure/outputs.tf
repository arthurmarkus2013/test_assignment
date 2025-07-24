output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "eks_cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.eks_cluster.name
}

output "prometheus_server_public_ip" {
    description = "prometheus server public ip"
    value = aws_instance.prometheus_server.public_ip
}

output "prometheus_server_public_dns" {
    description = "prometheus server public dns"
    value = aws_instance.prometheus_server.public_dns
}
