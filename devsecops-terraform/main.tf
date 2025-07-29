provider "aws" {
  region = var.aws_region
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "officekey"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/officekey.pem"
  file_permission = "0600"
}

resource "aws_instance" "devsecops_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 in us-east-1 (adjust if outdated)
  instance_type = "t2.medium"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "DevSecOps-EC2"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2_ip.txt"
  }
}
