terraform {

  required_version = ">= 1.0.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.52.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.2.0"
    }
  }

}