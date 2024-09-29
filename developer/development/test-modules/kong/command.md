```shell
docker run -it --name test-kong-module-envornment-box -v ~/.kube/config:/work/.kube/config -e KUBECONFIG=/work/.kube/config -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host developerhelperhub/kub-terr-work-env-box
```

**Verify pods and services**
```shell
kubectl -n microservices get pod --watch
kubectl -n microservices get svc
```

**Debug pods**
```shell
kubectl logs -n microservices pod/kong-kong-6bdd9944d-ql7tq
kubectl -n microservices describe pod/kong-kong-6bdd9944d-ql7tq
```

**Configure the domain**
```shell
vi /etc/hosts
127.0.0.1       admin.kong.myapp.com
```

**Login into postgresql**
```shell
kubectl -n microservices exec -it pod/kong-postgresql-0 -- psql -U mykong -d mykongdb
```

**Apply and Destroy module from terraform**
```shell
terraform apply -var="kind_cluster_name=microservices-development-cluster"
terraform destroy -var="kind_cluster_name=microservices-development-cluster" --target="module.microservices.module.kong"
```



**Deploy Item Service**
```shell
kubectl -n microservices -f test-modules/kong/microservices/item-service/kube-deployment.yaml apply
kubectl -n microservices -f test-modules/kong/microservices/item-service/kube-service.yaml apply

kubectl -n microservices get pod
kubectl -n microservices get svc
```

**Deploy Order Service**
```shell
kubectl -n microservices -f test-modules/kong/microservices/order-service/kube-deployment.yaml apply
kubectl -n microservices -f test-modules/kong/microservices/order-service/kube-service.yaml apply

kubectl -n microservices get pod
kubectl -n microservices get svc
```

**Deploy ingress resource of the kong proxy**
```shell
kubectl -n microservices apply -f test-modules/kong/ingress-resource.yaml 
```

**Test Admin API**
```shell
#Get admin API info
curl -i -X GET http://admin.kong.myapp.com/ 

#Get services
curl -i -X GET http://admin.kong.myapp.com/services/

#Get routes
curl -i -X GET http://admin.kong.myapp.com/routes/
```



**Create service in Kong**
```shell
curl -i -X POST http://admin.kong.myapp.com/services/ \
  --data "name=mes-item-service" \
  --data "url=http://mes-item-service.microservices.svc.cluster.local:8080"
```

**Verify the ingress resources**
```shell
kubectl -n microservices get ingress

NAME              CLASS    HOSTS                     ADDRESS     PORTS   AGE
kong-ingress      <none>   admin.kong.myapp.com      localhost   80      3h2m
mes-app-ingress   nginx    api.gateway.mes.app.com   localhost   80      147m
```