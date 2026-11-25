variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be launched"
  type        = string
}

variable "sg_id" {
  description = "Security Group ID attached to the EC2"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair name for SSH access"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common tags for compute resources"
  type        = map(string)
}