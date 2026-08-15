#=========================cloud provider information=========================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

#=========================aws credentials=====================================
provider "aws" {
  region = "${var.AWS_REGION}"
  access_key = "${var.akey}"
  secret_key = "${var.skey}"
}

