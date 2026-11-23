locals {
  env = terraform.workspace

  common_tags = {
    Project     = var.project_name
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}