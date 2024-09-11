#This script is where we define the common module needed for the parent and child modules.
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

