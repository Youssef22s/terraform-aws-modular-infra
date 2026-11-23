terraform {
  backend "s3" {
    bucket  = "youssef-tf-state-backend-2026"
    key     = "infra/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}