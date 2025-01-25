## Install MongoDB with helm

**Add the MongoDB Community Helm Repository**: First, you need to add the MongoDB community Helm repository to your Helm client:
```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

Create namespace on Kubernetes, we are installing the service insider this namespace.
```shell
kubectl create namespace database
```

Install MongoDB 
```shell
helm install my-mongodb -f mongo_value.yaml bitnami/mongodb --version 16.4.2 --namespace database
```

List the installed app
```shell
helm list  --namespace database

NAME      	NAMESPACE	REVISION	UPDATED                             	STATUS  	CHART         	APP VERSION
my-mongodb	database 	1       	2025-01-26 14:37:37.468911 +0530 IST	deployed	mongodb-16.4.2	8.0.4
```

We can check the service the node port and service type is configured properly
```shell
kubectl get svc -n database

NAME         TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
my-mongodb   NodePort   10.96.136.248   <none>        27017:31252/TCP   9m54s
```

Uninstall MongoDB
```shell
helm uninstall my-mongodb --namespace database
```



### Old Version -----
Terraform v1.9.3
on darwin_amd64
+ provider registry.terraform.io/hashicorp/helm v2.17.0
+ provider registry.terraform.io/hashicorp/kubernetes v2.35.1
+ provider registry.terraform.io/hashicorp/null v3.2.3
+ provider registry.terraform.io/hashicorp/random v3.6.3
+ provider registry.terraform.io/tehcyx/kind v0.5.1

## Clean Terraform plugins
Clean the ~/.terraform.d/plugins/