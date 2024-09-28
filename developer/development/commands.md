```shell
terraform workspace new microservices_dev
terraform workspace select microservices_dev

terraform init
terraform init -upgrade

terraform plan -var="kind_cluster_name=microservices-development-cluster"
terraform apply -var="kind_cluster_name=microservices-development-cluster"
terraform destroy -var="kind_cluster_name=microservices-development-cluster"
terraform destroy -var="kind_cluster_name=microservices-development-cluster"
```

```shell
chmod +x terraform-clean.sh
./terraform-clean.sh
```
