#This script is where we define the common module needed for the parent and child modules.
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "~> 3.6.3"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2.3"
    }
  }
}

