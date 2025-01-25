#This module is used to manage Helm-related resources and providers. The helm support version 2.14 or above.
terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
  }
}