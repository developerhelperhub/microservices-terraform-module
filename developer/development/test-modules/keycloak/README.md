# 00007 - Setup Keycloak on Kubernetes with help of Terraform
This section helps to basic understand how can we install the Keycloak in the Kubernetes Cluster with help of Terraform

## Setup local environment to build DevOps resources

I use docker containers to set up work environments for multiple applications([Setup Environment](https://dev.to/binoy_59380e698d318/setup-linux-box-on-local-with-docker-container-3k8)). This approach ensures fully isolated and maintainable environments for application development, allowing us to easily start and terminate these environments. Below is the Docker command to create the environment.
```shell
docker run -it --name test-microservices-module-envornment-box -v ~/.kube/config:/work/.kube/config -e KUBECONFIG=/work/.kube/config -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host developerhelperhub/kub-terr-work-env-box
```
The container contains Docker, Kubectl, Helm, Terraform, Kind, Git

## Setup Keycloak on Kubernetes Cluster 

I have created the terraform mdoules, which are available in the GitHub repository. You can download and set up Keycloak on a Kubernetes cluster, which runs locally in a Docker container.

**Clone the repository** onto your local Linux machine to get started.
```shell
git clone https://github.com/developerhelperhub/kuberentes-help.git
cd kuberentes-help/terraform/sections/00007/terraform
```
`main.tf` terraform script
```shell
module "microservices" {
    source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//microservices?ref=v1.1.0"
    kind_cluster_name = var.kind_cluster_name
    kind_http_port    = 80
    kind_https_port   = 443
    kubernetes_namespace = "microservices"
    keycloak_enable      = true
    keycloak_domain_name = var.keycloak_domain_name
    keycloak_admin_user     = "admin"
    keycloak_admin_password = "MyPassword2222@"
    keycloak_resources_requests_cpu    = "500m"
    keycloak_resources_requests_memory = "1024Mi"
    keycloak_resources_limit_cpu       = "500m"
    keycloak_resources_limit_memory    = "1024Mi"
    keycloak_db_password               = "MyPassword2222@"
    keycloak_db_admin_password         = "MyPassword2222@"
    keycloak_autoscaling_min_replicas  = 1
    keycloak_autoscaling_max_replicas  = 1
    keycloak_persistence_size          = "8Gi"
}
```
`variables.tf` terraform script
```shell
#This is variable arguments while running the terraform scripts
variable "kind_cluster_name" {
    type = string
    description = "Kind cluster name"
}
variable "keycloak_domain_name" {
    type = string
    description = "Keycloak domain name"
    default = "keycloak.myapp.com"
}
```
These Terraform scripts install and configure resources in the cluster:

- Create the Kubernetes cluster in docker container locally, the cluster name will be “microservices-development-cluster-control-plane”
- Install the ingress controller and exposes ports 80 and 443 to allow access to services from outside the cluster.
- Create a namespace called "microservices"
- Install Keycloak in the "microservices" namespace using a Helm chart.
- Keycloak username and password default “admin” and “MyPassword2222@”
- Set up the Keycloak Ingress resource to connect the Ingress controller with the Keycloak service.
- Configure the Keycloak container to run on port 80 and expose it to port 80 through the Ingress controller.
- Disabled monitoring Grafana and Prometheus

Cluster create terraform script under kind folder
```shell
terraform init
terraform plan  -var="kind_cluster_name=microservices-development-cluster"
terraform apply  -var="kind_cluster_name=microservices-development-cluster"
```
Following command verify the Jenkins Service
```shell
kubectl cluster-info #verify cluster info
kubectl get nodes -o wide #verify node

kubectl get namespace #verify the microservices namespace
kubectl get -n microservices pod #verify keycloak server is running
kubectl get -n microservices svc #verify keycloak service
```

As per my experience, this keycloak service take time to start and ready service. Make sure all services should be ready status before open the service. Eg:
```shell
kubectl -n microservices get pod --watch
NAME                    READY   STATUS    RESTARTS   AGE
keycloak-0              1/1     Running   0          6m11s
keycloak-postgresql-0   1/1     Running   0          7m6s
```

Following command use to login into postgres, the password will be prompt executed the command.
```shell
kubectl -n microservices exec -it pod/keycloak-postgresql-0 -- psql -U keycloak -d keycloakdb
```

**Note:** The Terraform state file should be kept secure and encrypted (using encryption at rest) because it contains sensitive information, such as usernames, passwords, and Kubernetes cluster details etc.
Add our domain to the bottom of the `/etc/hosts` file on your local machine. This configuration should not be inside our working Linux box “test-microservices-module-envornment-box”; it should be applied to your personal machine's `/etc/hosts` file. (you will need administrator access):
```shell
127.0.0.1       keycloak.myapp.com
```

Keycloak Username is "admin" and password "MyPassword2222@", URl "[http://keycloak.myapp.com](http://keycloak.myapp.com/)"

![](https://paper-attachments.dropboxusercontent.com/s_76908C315367696D7AAD18CAD203E53781FF2BD811857F5FB4684CFCB6A0B957_1727287093790_image.png)


## Reference
* [Helm Keyloak Install Example](https://github.com/developerhelperhub/kuberentes-help/tree/main/kubenretes/tutorials/sections/0011)

