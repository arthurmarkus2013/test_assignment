output "prometheus_server_public_ip" {
    description = "prometheus server public ip"
    value = aws_instance.prometheus_server.public_ip
}

output "prometheus_server_public_dns" {
    description = "prometheus server public dns"
    value = aws_instance.prometheus_server.public_dns
}

output "k3s_server_public_ip" {
    description = "k3s server public ip"
    value = aws_eip.k3s_server_eip.public_ip
}
