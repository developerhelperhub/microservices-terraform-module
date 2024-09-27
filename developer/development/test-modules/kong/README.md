This section helps to basic understand how can we install the Kong API Gateway in the Kubernetes Cluster with help of Terraform


![](https://paper-attachments.dropboxusercontent.com/s_4CDEA5DD1C3A599D48D76FDD95B2A00B1F90D5CB4645841C77D41A8B618835C8_1727537993959_Microservice-Kong+API+Gateway.drawio.png)

# Objective

In a microservice architecture, one of the key components is the API Gateway, which acts as a reverse proxy. Instead of clients communicating directly with multiple services, all requests are sent to a single server (the API Gateway), which routes them to the appropriate microservices based on routing policies configured in the reverse proxy server. One might wonder if a reverse proxy server like Nginx could replace an API Gateway. However, an API Gateway offers more advanced capabilities compared to a standard Nginx server. Below are some key differences:


- Plugins for authentication (JWT, OAuth2, key authentication).
- Rate limiting and request throttling.
- Logging and monitoring (integration with Prometheus, Grafana).
- Service discovery and health checks.
- Supports running in various environments, including Kubernetes and Docker.
- Load balancing with round-robin, least-connections, etc.
- Integration with third-party services like Datadog, Zipkin, and Cassandra.
- Manage the version API
- Manage the deployment strategy like “green/blue”, “canary” deployments
- Comes with built-in API management capabilities and is easier to set up for managing APIs. You can use its admin API to configure routes, services, and plugins dynamically.
- Built with scaling in mind, it easily integrates with tools like PostgreSQL and Cassandra for storing API configuration and scaling horizontally across many nodes.
## Setup local environment to build DevOps resources

I use docker containers to set up work environments for multiple applications([Setup Environment](https://dev.to/binoy_59380e698d318/setup-linux-box-on-local-with-docker-container-3k8)). This approach ensures fully isolated and maintainable environments for application development, allowing us to easily start and terminate these environments. Below is the Docker command to create the environment.
```shell
docker run -it --name test-microservices-module-envornment-box -v ~/.kube/config:/work/.kube/config -e KUBECONFIG=/work/.kube/config -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host developerhelperhub/kub-terr-work-env-box
```
The container contains Docker, Kubectl, Helm, Terraform, Kind, Git

# Setup Kong on Kubernetes Cluster 

I have created the terraform mdoules, which are available in the GitHub repository. You can download and set up Kong on a Kubernetes cluster, which runs locally in a Docker container.

**Clone the repository** onto your local Linux machine to get started.
```shell
git clone https://github.com/developerhelperhub/kuberentes-help.git
cd kuberentes-help/terraform/sections/00008/terraform
```

`main.tf` terraform script
```shell
module "microservices" {
    source = "git::https://github.com/developerhelperhub/microservices-terraform-module.git//microservices?ref=v1.2.0"
    kind_cluster_name = var.kind_cluster_name
    kind_http_port    = 80
    kind_https_port   = 443
    kubernetes_namespace = "microservices"
    kong_enable            = true
    kong_admin_domain_name = var.kong_admin_domain_name
    kong_proxy_domain_name = var.kong_proxy_domain_name
    kong_db_user           = "mykong"
    kong_db_name           = "mykongdb"
    kong_db_password       = "MyPassword2222@"
    kong_db_admin_password = "MyPassword2222@"
    kong_persistence_size  = "5Gi"
}
```
`variables.tf` terraform script
```shell
#This is variable arguments while running the terraform scripts
variable "kind_cluster_name" {
    type = string
    description = "Kind cluster name"
}
variable "kong_admin_domain_name" {
    type = string
    description = "Kong admin api domain name"
    default = "admin.kong.myapp.com"
}
variable "kong_proxy_domain_name" {
    type = string
    description = "Kong proxy domain name"
    default = "api.gateway.mes.app.com"
}
```
These Terraform scripts install and configure resources in the cluster:

- Create the Kubernetes cluster in docker container locally, the cluster name will be “microservices-development-cluster-control-plane”
- Install the ingress controller and exposes ports 80 and 443 to allow access to services from outside the cluster.
- Create a namespace called "microservices"
- Install Kong in the "microservices" namespace using a Helm chart.
- Kong postgres username and password default “mykong” and “MyPassword2222@”
- Setup the Kong admin API to create the service, route etc.
- Setup the Kong Ingress resource to connect the Ingress controller with the Kong Admin API and Kong Proxy services.
- Disabled monitoring Keycloak, Grafana and Prometheus

Cluster create terraform script under kind folder
```shell
terraform init
terraform plan  -var="kind_cluster_name=microservices-development-cluster"
terraform apply  -var="kind_cluster_name=microservices-development-cluster"
```
Following command verify the services
```shell
kubectl cluster-info #verify cluster info
kubectl get nodes -o wide #verify node

kubectl get namespace #verify the microservices namespace
kubectl get -n microservices pod #verify server is running
kubectl get -n microservices svc #verify service
```

As per my experience, this Kong services take time to start and ready to use it. Make sure all services should be ready status before open the service. Eg:
```shell
kubectl -n microservices get pod --watch
NAME                              READY   STATUS      RESTARTS   AGE
kong-kong-6bdd9944d-cp79n         2/2     Running     0          9m39s
kong-kong-init-migrations-fptth   0/1     Completed   0          9m39s
kong-postgresql-0                 1/1     Running     0          9m51s
```

Following command use to login into postgres, the password will be prompt executed the command.
```shell
kubectl -n microservices exec -it pod/kong-postgresql-0 -- psql -U mykong -d mykongdb
```

**Note:** The Terraform state file should be kept secure and encrypted (using encryption at rest) because it contains sensitive information, such as usernames, passwords, and Kubernetes cluster details etc.

Add our domain to the bottom of the `/etc/hosts` file on your local machine. This configuration should not be inside our working Linux box “test-microservices-module-envornment-box”; it should be applied to your personal machine's `/etc/hosts` file. (you will need administrator access):
```shell
127.0.0.1       api.gateway.mes.app.com
127.0.0.1       admin.kong.myapp.com
```
Verify the admin api service, this api response contains the kong API gateway details which is configured in the cluster.
****
    curl --location 'http://admin.kong.myapp.com/'
# Run the microservices in Kubernetes cluster

I have created two spring boot applications which are available in the docker hub repository for testing the routing the request to multiple microservices in the cluster. The microservice services will be running 8080 port

- “developerhelperhub/mes-item-service:1.0.0.1-SNAPSHOT”
- “developerhelperhub/mes-order-service:1.0.0.1-SNAPSHOT”

Deploy the **item service** in the cluster
```shell
kubectl -n microservices -f microservices/item-service/kube-deployment.yaml apply
kubectl -n microservices -f microservices/item-service/kube-service.yaml apply
```
Deploy the **order service** in the cluster
```shell
kubectl -n microservices -f microservices/order-service/kube-deployment.yaml apply
kubectl -n microservices -f microservices/order-service/kube-service.yaml apply
```
Following command verify the pods of microservices
```shell
NAME                                 READY   STATUS      RESTARTS   AGE
mes-item-service-544f54f9fd-2jkbs    1/1     Running     0          2m46s
mes-item-service-544f54f9fd-bm85t    1/1     Running     0          2m46s
mes-item-service-544f54f9fd-cddrh    1/1     Running     0          2m46s
mes-item-service-544f54f9fd-zdnjd    1/1     Running     0          2m46s
mes-order-service-5f7cf68dd9-79z48   1/1     Running     0          2m39s
mes-order-service-5f7cf68dd9-qx2dv   1/1     Running     0          2m39s
mes-order-service-5f7cf68dd9-w28nt   1/1     Running     0          2m39s
```
Following command verify the services are running in the correct port 
```shell
kubectl -n microservices get svc
NAME                           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
kong-kong-admin                ClusterIP   10.96.215.110   <none>        8001/TCP                        24m
kong-kong-manager              NodePort    10.96.185.130   <none>        8002:32038/TCP,8445:31091/TCP   24m
kong-kong-proxy                ClusterIP   10.96.125.115   <none>        80/TCP,443/TCP                  24m
kong-kong-validation-webhook   ClusterIP   10.96.180.81    <none>        443/TCP                         24m
kong-postgresql                ClusterIP   10.96.129.217   <none>        5432/TCP                        24m
kong-postgresql-hl             ClusterIP   None            <none>        5432/TCP                        24m
mes-item-service               ClusterIP   10.96.241.39    <none>        8080/TCP                        3m32s
mes-order-service              ClusterIP   10.96.252.164   <none>        8080/TCP                        3m25s
```

# Create Service and Route path in Kong API 

Kong Admin API provides endpoints to create the services and its route path of the services.

Create the service of item-service
```shell
curl --location 'http://admin.kong.myapp.com/services/' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=mes-item-service' \
--data-urlencode 'url=http://mes-item-service.microservices.svc.cluster.local:8080'
```
Create the route path of item-service. We are routing the all request into “item-service” if the path contains “/item-service”
```shell
curl --location 'http://admin.kong.myapp.com/routes/' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'service.id=<service_id>' \
--data-urlencode 'paths%5B%5D=/item-service'
```
**Note** : Replace the `<service_id>` with actual service id of item-service.

Create the service of order-service
```shell
curl --location 'http://admin.kong.myapp.com/services/' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'name=mes-order-service' \
--data-urlencode 'url=http://mes-order-service.microservices.svc.cluster.local:8080'
```
Create the route path of item-service. We are routing the all request into “order-service” if the path contains “/item-service”
```shell
curl --location 'http://admin.kong.myapp.com/routes/' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'service.id=<service_id>' \
--data-urlencode 'paths%5B%5D=/order-service'
```
**Note** : Replace the `<service_id>` with actual service id of item-service.

Testing the endpoints of Item service
```shell
#get the list of items
curl --location 'http://api.gateway.mes.app.com/item-service/items'
#get the service info
curl --location 'http://api.gateway.mes.app.com/item-service/actuator/info'
#get the helth info
curl --location 'http://api.gateway.mes.app.com/item-service/actuator/health'
```
Testing the endpoints of Item service
```shell
#get the list of items
curl --location 'http://api.gateway.mes.app.com/order-service/items'
#get the service info
curl --location 'http://api.gateway.mes.app.com/order-service/actuator/info'
#get the helth info
curl --location 'http://api.gateway.mes.app.com/order-service/actuator/health'
```
Note : Postman collections and environment files are available in the repo

# Reference
* [High Availability and Scalability deployment Microservices on Kubernetes cluster](https://dev.to/binoy_59380e698d318/high-availability-and-scalability-deployment-microservices-on-kubernetes-cluster-2p51)
* [Helm Value](https://github.com/Kong/charts/blob/main/charts/kong/values.yaml)
* [Kong Config](https://github.com/Kong/kong/blob/master/kong.conf.default)
* [Kong Traditional DB](https://docs.konghq.com/gateway/3.8.x/production/deployment-topologies/traditional/)
* [Kong Database Config](https://docs.konghq.com/gateway/3.8.x/reference/configuration/#datastore-section)
* [Admin API Docs OSS](https://docs.konghq.com/gateway/api/admin-oss/latest/)
* [Third Party Support](https://docs.konghq.com/gateway/3.8.x/support/third-party/#data-stores)
* [Install in Kubernetes](https://docs.konghq.com/gateway/latest/install/kubernetes/admin/)
* [DB Configuration](https://docs.konghq.com/gateway/latest/install/kubernetes/proxy/)

