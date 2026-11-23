resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${local.env}-private-key.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.project_name}-${local.env}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = local.common_tags
}