provider "aws" {
  region = "ap-south-1"
}

# Generate a private/public key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "officekey"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/officekey.pem"
  file_permission = "0600"
}

# Launch EC2 instance in ap-south-1 (Mumbai)
resource "aws_instance" "devsecops_instance" {
  ami           = "ami-007020fd9c84e18c7" # ✅ Ubuntu 20.04 LTS (x86) for ap-south-1 as of July 2025
  instance_type = "t2.medium"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "DevSecOps-EC2"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2_ip.txt"
  }
}
