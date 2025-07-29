output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.devsecops_instance.public_ip
}


output "private_key_pem" {
  description = "Private key content"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}
