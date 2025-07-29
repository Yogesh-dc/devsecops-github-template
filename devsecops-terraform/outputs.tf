
output "public_ip" {
  value = aws_instance.devsecops_instance.public_ip
}
output "public_ip" {
  value = aws_instance.devsecops.public_ip
}

output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
