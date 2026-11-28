# Modular AWS Cloud Infrastructure with Terraform

A modular and automated **Infrastructure as Code (IaC)** project that provisions AWS cloud infrastructure using Terraform. The project demonstrates practical DevOps and cloud engineering practices, including reusable modules, remote state management, multi-environment deployments, automated SSH key management, and infrastructure automation.

The infrastructure provides a reusable foundation for deploying web workloads on AWS while applying Terraform best practices.

---

## Architecture Overview

The project provisions a custom AWS environment in **US East (N. Virginia)** using a modular Terraform architecture.

### Infrastructure Components

- **Amazon VPC:** Custom VPC with a `10.0.0.0/16` CIDR block.
- **Public Subnets:** Two public subnets distributed across Availability Zones.
- **Private Subnets:** Two private subnets for internal workloads.
- **Internet Gateway:** Provides internet connectivity for public resources.
- **Security Groups:** Controls inbound HTTP and SSH traffic.
- **Amazon EC2:** Ubuntu 22.04 LTS instance running an Nginx web server.
- **Amazon S3:** Remote Terraform state storage with versioning and server-side encryption.
- **TLS Provider:** Dynamically generates RSA 4096-bit SSH key pairs.

### Architecture Diagram

```text
+-----------------------------------------------------------------------------------+
|                                  AWS Cloud (us-east-1)                            |
|                                                                                   |
|  +-----------------------------------------------------------------------------+  |
|  | Custom VPC (10.0.0.0/16)                                                    |  |
|  |                                                                             |  |
|  |  +-----------------------------------+   +-------------------------------+  |  |
|  |  | Public Subnet 1 (10.0.1.0/24)     |   | Public Subnet 2 (10.0.2.0/24) |  |  |
|  |  |  +-----------------------------+  |   |                               |  |  |
|  |  |  | Security Group (HTTP/SSH)   |  |   +-------------------------------+  |  |
|  |  |  |  +-----------------------+  |  |                                      |  |
|  |  |  |  | EC2 Instance (Ubuntu) |  |  |   +-------------------------------+  |  |
|  |  |  |  | Nginx via user_data   |  |  |   | Private Subnets (2 AZs)       |  |  |
|  |  |  |  +-----------------------+  |  |   | 10.0.10.0/24 & 10.0.20.0/24   |  |  |
|  |  |  +-----------------------------+  |   +-------------------------------+  |  |
|  |  +-----------------|-----------------+                                      |  |
|  |                    |                                                        |  |
|  |           [Internet Gateway]                                                |  |
|  +--------------------|--------------------------------------------------------+  |
+-----------------------|-----------------------------------------------------------+
                        |
                [User / SSH & HTTP]
                        ▲
                        │ (Generated via TLS Provider & Saved Locally)
              [RSA 4096-bit Key Pair]

+-----------------------------------------------------------------------------------+
| Remote State Backend: Amazon S3 (Versioning Enabled + AES-256 Encryption)         |
+-----------------------------------------------------------------------------------+
```

---

## Key Features & Technical Highlights

### 1. Modular Infrastructure Architecture

- Designed reusable Terraform modules with clear separation of responsibilities.
- **Network Module:** Provisions VPC, public/private subnets, Internet Gateway, and route tables.
- **Security Module:** Manages Security Groups and inbound traffic rules.
- **Compute Module:** Provisions EC2 instances and handles Ubuntu AMI discovery.

### 2. Remote State Management

- Implemented a separate bootstrap configuration to provision the S3 backend.
- Configured Amazon S3 as the remote Terraform state backend.
- Enabled S3 versioning to support state recovery.
- Enabled server-side encryption using AES-256.
- Separated backend infrastructure from the main project configuration.

### 3. Automated SSH Key Management

- Generated RSA 4096-bit SSH key pairs dynamically using the Terraform TLS provider.
- Registered public keys in AWS using `aws_key_pair`.
- Saved private keys locally using the Local provider.
- Applied restrictive file permissions (`0400`) to generated private keys.

### 4. Multi-Environment Deployment

- Used Terraform Workspaces to manage separate `dev` and `prod` environments.
- Implemented conditional resource configuration based on the active workspace.
- Configured environment-specific EC2 instance types:
  - **Development:** `t2.micro`
  - **Production:** `t3.small`
- Used Terraform locals to centralize environment-specific configurations.

### 5. Dynamic Resource Configuration

- Used Terraform data sources to dynamically retrieve the latest Ubuntu 22.04 LTS AMI.
- Implemented `templatefile()` to inject environment-specific variables into EC2 user data.
- Automated Nginx installation and web server initialization.

### 6. Terraform Best Practices

- Defined reusable input variables with validation rules.
- Used `locals` to avoid configuration duplication (DRY principle).
- Implemented structured outputs for resource information and connection commands.
- Defined Terraform and provider version constraints.
- Used `.gitignore` to exclude sensitive files and Terraform state artifacts.

---

## Repository Structure

```text
terraform-aws-modular-infra/
│
├── bootstrap/
│   └── main.tf
│
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── compute/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── init.sh
│
├── backend.tf
├── providers.tf
├── main.tf
├── locals.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── .gitignore
└── README.md
```

---

## Prerequisites

Before deploying the infrastructure, make sure you have:

- [Terraform CLI](https://developer.hashicorp.com/terraform/install) (`>= 1.5.0`)
- [AWS CLI](https://aws.amazon.com/cli/)
- An AWS account.
- AWS credentials configured with the required IAM permissions.

Configure AWS credentials:

```bash
aws configure
```

Verify your AWS identity:

```bash
aws sts get-caller-identity
```

---

## Deployment Guide

### Step 1: Bootstrap the Remote Backend

The bootstrap configuration creates the S3 bucket used to store Terraform remote state.

```bash
cd bootstrap

terraform init
terraform validate
terraform plan
terraform apply

cd ..
```

**Important:** Update the S3 bucket name in `backend.tf` to match the bucket created by the bootstrap configuration.

### Step 2: Configure Project Variables

Create your local Terraform variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update the values according to your AWS environment.

### Step 3: Initialize Terraform

Initialize the main Terraform configuration and connect it to the S3 remote backend.

```bash
terraform init
```

### Step 4: Validate and Deploy

Format and validate the Terraform configuration before provisioning resources.

```bash
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

### Step 5: Deploy Multiple Environments

Create and deploy the development environment:

```bash
terraform workspace new dev
terraform plan
terraform apply
```

Create and deploy the production environment:

```bash
terraform workspace new prod
terraform plan
terraform apply
```

Each workspace maintains a separate Terraform state, allowing environment-specific infrastructure management.

### Step 6: Access the EC2 Instance

Retrieve the deployment outputs:

```bash
terraform output
```

- Open `web_server_url` in your browser to access the Nginx web server.
- Execute `ssh_connection_command` to connect to the EC2 instance.

### Step 7: Clean Up Infrastructure

Destroy resources in the active workspace:

```bash
terraform destroy
```

Switch to the other workspace and repeat the process if necessary.

**Note:** The S3 backend bucket is managed separately by the bootstrap configuration and must be cleaned up independently after the main infrastructure is destroyed.

---

## Security Considerations

- Private SSH keys are generated locally and should never be committed to GitHub.
- Terraform state files may contain sensitive information and should not be publicly accessible.
- AWS credentials should be managed outside the repository.
- Security Group rules should follow the principle of least privilege.
- Production SSH access should be restricted to trusted IP addresses or replaced with AWS Systems Manager Session Manager.

---

## Skills Demonstrated

`Terraform` · `AWS` · `Infrastructure as Code` · `Terraform Modules` · `Terraform Workspaces` · `Remote State Management` · `Amazon S3` · `Amazon EC2` · `VPC Networking` · `Linux` · `Nginx` · `SSH Key Management` · `Automation` · `Cloud Infrastructure`

---

**Author:** Youssef Mohamed Anwar

**Project Focus:** AWS Cloud Infrastructure Automation & Terraform