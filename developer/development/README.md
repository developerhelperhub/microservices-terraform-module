# Development - Run Microservices Applications in Kubernetes Cluster locally
These Terraform scripts help set up Microservices applications necessary for application development. The module is hosted in a GitHub repository called ["Microservices Terraform Module."](https://github.com/developerhelperhub/microservices-terraform-module).

The following applications will be deployed locally in a Kubernetes cluster.
* Keycloak
* Prometheus
* Grafana

**Root Main Terraform Script** `main.tf`
```shell
module "microservices" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//microservices?ref=v1.1.0"

  kind_cluster_name = var.kind_cluster_name
  kind_http_port    = 80
  kind_https_port   = 443

  kubernetes_namespace = "microservices"

  keycloak_admin_user     = "admin"
  keycloak_admin_password = "MyPassword2222@"

  keycloak_resources_requests_cpu    = "500m"
  keycloak_resources_requests_memory = "1024Mi"
  keycloak_resources_limit_cpu       = "500m"
  keycloak_resources_limit_memory    = "1024Mi"
  keycloak_db_password="MyPassword2222@"
  keycloak_db_admin_password="MyPassword2222@"
  keycloak_autoscaling_min_replicas  = 1
  keycloak_autoscaling_max_replicas  = 1
  keycloak_persistence_size          = "8Gi"

  kube_prometheus_stack_enable = false
  prometheus_domain_name       = var.prometheus_domain_name

  grafana_domain_name    = var.grafana_domain_name

  prometheus_alertmanager_enabled      = true
  prometheus_persistent_volume_enabled = true
  prometheus_persistent_volume_size    = "5Gi"
}
```

## Setup local environment to build Microservices resources
I use docker containers to set up work environments for multiple applications([Setup Environment](https://dev.to/binoy_59380e698d318/setup-linux-box-on-local-with-docker-container-3k8)). This approach ensures fully isolated and maintainable environments for application development, allowing us to easily start and terminate these environments. Below is the Docker command to create the environment.
```shell
docker run -it --name test-microservices-module-envornment-box -v ~/.kube/config:/work/.kube/config -e KUBECONFIG=/work/.kube/config -v ${HOME}/root/ -v ${PWD}:/work -w /work --net host developerhelperhub/kub-terr-work-env-box
```
The container contains Docker, Kubectl, Helm, Terraform, Kind, Git

## Setup Microservices Applications on Kubernetes Cluster 
I have developed all the necessary Terraform scripts, which are available in a GitHub repository. You can download these scripts to set up various Microservices applications, which are deployed on a Kubernetes cluster running locally in a Docker container.

**Clone the repository** onto your local Linux machine to get started.
```shell
git https://github.com/developerhelperhub/microservices-terraform-module.git
cd developer/development/
```

Run the following commands to install the resources
```shell
terraform init
terraform plan  -var="kind_cluster_name=microservices-development-cluster"
terraform apply  -var="kind_cluster_name=microservices-development-cluster"
```

**Note:** The Terraform state file should be kept secure and encrypted (using encryption at rest) because it contains sensitive information, such as usernames, passwords, and Kubernetes cluster details etc.

Add our domain to the bottom of the `/etc/hosts` file on your local machine. This configuration should not be inside our working Linux box “test-microservices-module-envornment-box”; it should be applied to your personal machine's `/etc/hosts` file. 
(you will need administrator access):
```shell
127.0.0.1       prometheus.microservices.com
127.0.0.1       grafana.microservices.com
127.0.0.1       keycloak.myapp.com
```
## Applications 
* Keycloak Username is "admin" and password "MyPassword2222@", URl "http://keycloak.myapp.com"
* Prometheus URL “http://prometheus.microservices.com/”
* Grafana Username is "admin", password will be available in the Terraform state file, URL “http://grafana.microservices.com/”


## Reference
* [Maintain Module Version](https://github.com/developerhelperhub/kuberentes-help/tree/main/terraform/sections/00004)
* [Setup Kubernetes Cluster on Docker with help of Kind](https://github.com/developerhelperhub/kuberentes-help/tree/main/terraform/sections/00001)
* [Keycloak setup with helm](https://github.com/developerhelperhub/kuberentes-help/tree/main/kubenretes/tutorials/sections/0011)