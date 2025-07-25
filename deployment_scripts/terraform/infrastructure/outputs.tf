output "prometheus_server_public_ip" {
    description = "prometheus server public ip"
    value = aws_instance.prometheus_server.public_ip
}

output "prometheus_server_public_dns" {
    description = "prometheus server public dns"
    value = aws_instance.prometheus_server.public_dns
}
