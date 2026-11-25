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

module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  azs                  = var.availability_zones
  env                  = local.env

  common_tags = local.common_tags
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.network.vpc_id
  env         = local.env
  common_tags = local.common_tags
}

module "compute" {
  source        = "./modules/compute"
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnet_ids[0]
  sg_id         = module.security.sg_id
  key_name      = aws_key_pair.ec2_key.key_name
  env           = local.env
  common_tags   = local.common_tags
}