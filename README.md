# Terraform VPC Module

This Terraform module creates a **VPC** with customizable subnets (public and private), an **Internet Gateway** (for public subnets), and associated **route tables**. It provides a reusable and modular approach for setting up AWS networking resources.

## 📝 Table of Contents

- [Overview](#overview)
- [Usage](#usage)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Requirements](#requirements)
- [Example](#example)
- [Contributing](#contributing)
- [License](#license)

## Overview

This Terraform module enables users to create a **Virtual Private Cloud (VPC)** in AWS. The module allows users to specify VPC CIDR blocks, subnet configurations, and create public or private subnets. Additionally, if any subnets are marked as public, an **Internet Gateway (IGW)** is automatically created and attached to the VPC.

Key features:
- Create VPC with customizable CIDR block.
- Support for public and private subnets.
- Automatically create and attach an Internet Gateway for public subnets.
- Route table associations for public subnets.

## Usage

To use this module in your own Terraform configuration, follow these steps:

1. Clone this repository to your local machine or use it as a module in your Terraform code.
2. Configure the inputs as needed in your `main.tf`.
3. Apply the configuration with `terraform apply`.

### Example

```hcl
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"  # Path to your module
  
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "my-test-vpc"
  }

  subnet_config = {
    public_subnet = {
      cidr_block = "10.0.0.0/24"
      az         = "us-east-1a"
      public     = true
    }

    private_subnet = {
      cidr_block = "10.0.1.0/24"
      az         = "us-east-1b"
      public     = false
    }
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}
