```shell
terraform init
terraform init -upgrade

terraform workspace new microservices_dev
terraform workspace select microservices_dev

terraform plan
terraform apply  -var="kind_cluster_name=microservices-dev-cluster"
terraform destroy -var="kind_cluster_name=microservices-de-cluster"

terraform workspace select default
terraform workspace delete microservices_dev

terraform workspace new microservices_prod
terraform workspace select microservices_prod

terraform plan
terraform apply  -var="kind_cluster_name=microservices-prod-cluster"
terraform destroy -var="kind_cluster_name=microservices-prod-cluster"

terraform workspace select default
terraform workspace delete microservices_prod

chmod +x terraform-clean.sh
./terraform-clean.sh
```

# References
