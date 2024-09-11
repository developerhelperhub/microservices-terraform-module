#!/bin/bash

# Remove the .terraform directory
echo "Removing .terraform directory..."
rm -rf .terraform
rm -rf .terraform.lock.hcl

# Remove Terraform state files
echo "Removing terraform.tfstate and terraform.tfstate.backup..."
rm -f terraform.tfstate terraform.tfstate.backup
rm -rf terraform.tfstate.d

# Remove Terraform plan files
echo "Removing *.plan files..."
rm -f *.plan


echo "Removing *-config files of kind..."
rm -f *-config

echo "Removing .kube"
rm -rf .kube

echo "Terraform cleanup completed."