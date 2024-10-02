# main.tf

# This file serves as the main entry point for the Terraform configuration.
# Provider configuration is defined in providers.tf
# Variables are defined in variables.tf
# Resources are defined in separate files: key_pair.tf, security_group.tf, instance.tf, local_files.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}