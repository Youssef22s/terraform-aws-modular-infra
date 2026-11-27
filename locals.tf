locals {
  env = terraform.workspace

  selected_instance_type = local.env == "prod" ? "t3.small" : var.instance_type

  common_tags = {
    Project     = var.project_name
    Environment = local.env
    ManagedBy   = "Terraform"
  }
}