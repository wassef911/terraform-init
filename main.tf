terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
  }
}

provider "aws" {
  region = var.default_aws_region
}

variable "environments" {}

module "backend_ec2_instance" {
  source = "./modules/backend"

  for_each = { for env in var.environments : env.env_short => env }

  aws_region    = each.value.aws_region
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  env_short     = each.value.env_short
}
