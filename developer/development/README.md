# Development - Run Microservices Applications in Kubernetes Cluster locally
These Terraform scripts help set up Microservices applications necessary for application development. The module is hosted in a GitHub repository called ["Microservices Terraform Module."](https://github.com/developerhelperhub/microservices-terraform-module).

The following applications will be deployed locally in a Kubernetes cluster.
* Jenkins
* JFrog
* Prometheus
* Grafana
* Jenkins Maven Agent Config

**Root Main Terraform Script** `main.tf`
```shell
module "microservices" {
  source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//microservices?ref=v1.0.0"

  kind_cluster_name = var.kind_cluster_name
  kind_http_port    = 80
  kind_https_port   = 443

  kubernetes_namespace = "microservices"

  jenkins_enable         = true
  jenkins_domain_name    = var.jenkins_domain_name
  jenkins_admin_username = var.jenkins_admin_username
  jenkins_admin_password = "MyPassword12920"

  jfrog_enable              = true
  jfrog_domain_name         = var.jfrog_domain_name

  kube_prometheus_stack_enable = false
  prometheus_domain_name       = var.prometheus_domain_name

  grafana_domain_name    = var.grafana_domain_name

  prometheus_alertmanager_enabled      = true
  prometheus_persistent_volume_enabled = true
  prometheus_persistent_volume_size    = "5Gi"

  jenkins_agent_maven_config_enabled = true
  jenkins_agent_maven_config_pvc_storage_size = "5Gi"
  jenkins_agent_maven_config_pv_storage_size = "5Gi"

  jenkins_agent_maven_config_app_repository_id="my-app-virtual-snapshot"
  jenkins_agent_maven_config_app_repository_url="http://jfrog-artifactory-oss.microservices.svc.cluster.local:8081/artifactory/my-app-virtual-snapshot/"
  jenkins_agent_maven_config_app_repository_username=var.jenkins_agent_maven_config_app_repository_username
  jenkins_agent_maven_config_app_repository_password=var.jenkins_agent_maven_config_app_repository_password
  jenkins_agent_maven_config_app_central_repository_id="my-app-central-snapshot"
  jenkins_agent_maven_config_app_central_repository_url="http://jfrog-artifactory-oss.microservices.svc.cluster.local:8081/artifactory/my-app-central-snapshot"
  jenkins_agent_maven_config_app_central_repository_username=var.jenkins_agent_maven_config_app_central_repository_username
  jenkins_agent_maven_config_app_central_repository_password=var.jenkins_agent_maven_config_app_central_repository_password
  jenkins_agent_maven_config_maven_master_password=var.jenkins_agent_maven_config_maven_master_password
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

**Configure the Environment variables of Maven Secretes for Maven Agent Config Module**
Following the environments variables need to configure in the `~/.bash_profile`, give the proper encrypted password and user names in the variables
```shell
export set TF_VAR_jenkins_agent_maven_config_app_repository_username="<user>"
export set TF_VAR_jenkins_agent_maven_config_app_repository_password="<password>"
export set TF_VAR_jenkins_agent_maven_config_app_central_repository_username="<user>"
export set TF_VAR_jenkins_agent_maven_config_app_central_repository_password="<password>"
export set TF_VAR_jenkins_agent_maven_config_maven_master_password="<maven master password>"
```

Run the following commands to install the resources
```shell
terraform init
terraform plan -var="kind_cluster_name=microservices-test-cluster"
terraform apply -var="kind_cluster_name=microservices-test-cluster"
```

**Note:** The Terraform state file should be kept secure and encrypted (using encryption at rest) because it contains sensitive information, such as usernames, passwords, and Kubernetes cluster details etc.

Add our domain to the bottom of the `/etc/hosts` file on your local machine. This configuration should not be inside our working Linux box “test-jenkins-module-envornment-box”; it should be applied to your personal machine's `/etc/hosts` file. 
(you will need administrator access):
```shell
127.0.0.1       jenkins.microservices.com
127.0.0.1       jfrog.microservices.com
127.0.0.1       prometheus.microservices.com
127.0.0.1       grafana.microservices.com
```
## Applications 
* Jenkins Username and password will be available in the Terraform state file, URL “http://jenkins.microservices.com/”
* JFrog username and password are "admin" and "password", URL “http://jfrog.microservices.com/”
* Prometheus URL “http://prometheus.microservices.com/”
* Grafana Username is "admin", password will be available in the Terraform state file, URL “http://grafana.microservices.com/”


## Reference
* [Maintain Module Version](https://github.com/developerhelperhub/kuberentes-help/tree/main/terraform/sections/00004)
* [Jfrog Deployment in Kubernetes](https://github.com/developerhelperhub/kuberentes-help/tree/main/terraform/sections/00005)
* [Module Design Jenkins Deployment in Kubernetes](https://github.com/developerhelperhub/kuberentes-help/tree/main/terraform/sections/00003)
* [Setup Terraform - Jenkins](https://github.com/developerhelperhub/kuberentes-help/tree/main/terraform/sections/00002)
* [Setup Kubernetes Cluster on Docker with help of Kind](https://github.com/developerhelperhub/kuberentes-help/tree/main/terraform/sections/00001)