output "prometheus_server_public_ip" {
    description = "prometheus server public ip"
    value = aws_instance.prometheus_server.public_ip
}

output "prometheus_server_private_ip" {
    description = "prometheus server private ip"
    value = aws_instance.prometheus_server.private_ip
}

output "k3s_server_public_ip" {
    description = "k3s server public ip"
    value = aws_eip.k3s_server_eip.public_ip
}

output "k3s_server_private_ip" {
    description = "k3s server private ip"
    value = aws_eip.k3s_server_eip.private_ip
}

output "bastion_server_public_ip" {
  description = "public ip address of bastion server"
  value = aws_instance.bastion_server.public_ip
}

output "bastion_server_private_ip" {
  description = "private ip address of bastion server"
  value = aws_instance.bastion_server.private_ip
}
