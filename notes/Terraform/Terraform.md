# Terraform HashiCorp

- Multiple Cloud Platforms
- Configurations for Humans
- Track Resources with State
- Collaborate with Terraform Cloud

## Configuring .tf

### Terraform

### Provider

### Resource

```tf
// Pull down aws configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.16"
    }
  }

  required_version = ">= 1.2.0"
}

// Configures the specified provider
provider "aws" {
  region = "ap-southeast-2"
}

// Define components of your infrastructure
// Has two strings: resource type / name
resource "aws_s3_bucket" "xg-chris" {
  bucket = "xg-chris-bucket"

  tags = {
    Name        = "Chris' Bucket"
    Environment = "Test"
  }
}
```

## Initialise Terraform

```bash
// init creates .terraform folder in your working directory
terraform init

// formats the .tf files
terraform fmt

// validates your .tf files
terraform validate

// runs .tf file
terraform apply

// detroys action
terraform destroy
```
