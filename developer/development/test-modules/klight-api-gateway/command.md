```shell
docker run -it --name test-microservices-module-envornment-box -v ~/.kube/config:/work/.kube/config -e KUBECONFIG=/work/.kube/config -v ${HOME}:/root/ -v ${PWD}:/work -w /work --net host developerhelperhub/kub-terr-work-env-box

helm repo update
helm repo add bitnami https://charts.bitnami.com/bitnami

helm search repo bitnami/mongodb
helm search repo bitnami/redis

terraform init --upgrade
terraform plan  -var="kind_cluster_name=microservices-development-cluster"
terraform apply  -var="kind_cluster_name=microservices-development-cluster"
```

**Verify pods and services**
```shell
kubectl -n microservices get pod --watch
kubectl -n microservices get svc
```

**Debug Mongo Pod**
```shell
kubectl -n microservices exec -it pod/klight-api-gateway-mongodb-64f55d8497-jdk8v -- mongosh -u klight-api-gateway -p klight-api-gateway --authenticationDatabase klight-api-gateway

test> collections
```

**Debug Redis Pod**
```shell
kubectl -n microservices exec -it klight-api-gateway-redis-master-0 -- redis-cli 

localhost:6379> ping
(error) NOAUTH Authentication required.
localhost:6379> AUTH password
(error) WRONGPASS invalid username-password pair or user is disabled.
localhost:6379> AUTH redis-mas-pass
OK
localhost:6379> ping
PONG
localhost:6379> KEYS *
(empty array)
```

#### Set user
```shell
ACL SETUSER klight-redis-user
```

#### Set password
```shell
ACL SETUSER klight-redis-user on >klight-redis-pass ~kag_openid_session:* &* +get +set +del
```

##### Common Command Categories
* Data Access Commands: `+get, +set, +del, +mget, +mset, etc.`
* Data Structure Commands: `+hget, +hset, +lpush, +lpop, etc.`
* Administrative Commands: `+flushall, +shutdown, +config, etc.`

#### test authentication
```shell
AUTH klight-redis-user klight-redis-pass
```

#### get and set key
```shell
SET kag_openid_session:mykey "myvalue"
GET kag_openid_session:mykey
```

#### Delete all keys from database
```shell
FLUSHDB
 ```

**Delete resources=**
```shell
```shell
kubectl -n microservices delete configmap klight-api-gateway-config
kubectl -n microservices delete configmap klight-api-gateway-nginx-config
kubectl -n microservices delete secret klight-api-gateway-secret

kubectl -n microservices -f test-modules/klight-api-gateway/kube-deployment.yaml delete
kubectl -n microservices -f test-modules/klight-api-gateway/kube-service.yaml delete
kubectl -n microservices -f test-modules/klight-api-gateway/ingress-resource.yaml delete
```

**Deploy API Gateway**
```shell
kubectl -n microservices create configmap klight-api-gateway-config --from-file=config.yaml=test-modules/klight-api-gateway/config-kub.yaml
kubectl -n microservices create configmap klight-api-gateway-nginx-config --from-file=nginx.conf=test-modules/klight-api-gateway/nginx-kub.conf
kubectl -n microservices create secret generic klight-api-gateway-secret --from-file=config-security.yaml=test-modules/klight-api-gateway/config-security-kub.yaml

kubectl -n microservices -f test-modules/klight-api-gateway/kube-deployment.yaml apply 
kubectl -n microservices -f test-modules/klight-api-gateway/kube-service.yaml apply
kubectl -n microservices -f test-modules/klight-api-gateway/ingress-resource.yaml apply
```

**Debug resources**
```shell
kubectl -n microservices get configmap klight-api-gateway-config -o yaml
kubectl -n microservices get configmap klight-api-gateway-nginx-config
kubectl -n microservices get secrets klight-api-gateway-secret -o yaml

kubectl -n microservices get pod
kubectl -n microservices get pod --watch
kubectl -n microservices logs klight-api-gateway-6d78b88ccc-5xl4r -f
kubectl -n microservices describe klight-api-gateway-6d78b88ccc-mlfww
kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-mlfww -- cat /usr/local/openresty/nginx/config.yaml
kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-mlfww -- cat /usr/local/openresty/nginx/config-security.yaml
kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-mlfww -- cat /usr/local/openresty/nginx/conf/nginx.conf
kubectl -n microservices get svc


kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-mlfww -- nslookup klight-api-gateway-redis-master.microservices.svc.cluster.local
kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-mlfww -- nc -vz klight-api-gateway-redis-master.microservices.svc.cluster.local 6379

kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-qjcsr  -- nc -vz keycloak.microservices.svc.cluster.local 80
kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-qjcsr  -- nc -vz keycloak.myapp.com 80
kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-2rwpc -- curl http://keycloak.microservices.svc.cluster.local:80/realms/klight-api-gateway/protocol/openid-connect/token/introspect

curl --location 'http://api.gateway.mes.app.com/item-service/items' 
```

**Configure the domain**
```shell
vi /etc/hosts
127.0.0.1       api.gateway.mes.app.com
127.0.0.1       api.gateway.mes.app.com
```

**Login into postgresql**
```shell
kubectl -n microservices exec -it pod/kong-postgresql-0 -- psql -U mykong -d mykongdb
```

**Destroy module from terraform**
```shell
terraform destroy -var="kind_cluster_name=microservices-development-cluster" --target="module.microservices.module.klight_api_gateway"
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


```shell
curl -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "token=YOUR_ACCESS_TOKEN" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET" \
  "https://keycloak.example.com/auth/realms/YOUR_REALM/protocol/openid-connect/token/introspect"
```

```shell
kubectl -n microservices exec -it klight-api-gateway-6d78b88ccc-5xl4r -- curl -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=klight-api-gateway-openid-connect-authorize-code" \
  -d "client_secret=LXMpQ6HV5sQClXblnPteEbPt8Tie8iZk" \
  -d "token=eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJXQnZTODBwN1ZrUEJoem5vZjNoendvMlVtNVdVWC1HOHc3ZGt3VTlrbWljIn0.eyJleHAiOjE3NDA5MDQ5MjcsImlhdCI6MTc0MDkwNDYyNywianRpIjoiMjJmOTY0NDQtNWY5NS00NjRkLTgxODYtYmNkYjg1ODA5ZTgxIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrLm15YXBwLmNvbS9yZWFsbXMva2xpZ2h0LWFwaS1nYXRld2F5IiwiYXVkIjoia2xpZ2h0LWFwaS1nYXRld2F5LW9wZW5pZC1jb25uZWN0LWF1dGhvcml6ZS1jb2RlIiwic3ViIjoiM2NlNzdjZWYtYWY0OC00ZjRlLWE0ZjktYTA4YTYwMDZlMmUyIiwidHlwIjoiSUQiLCJhenAiOiJrbGlnaHQtYXBpLWdhdGV3YXktb3BlbmlkLWNvbm5lY3QtYXV0aG9yaXplLWNvZGUiLCJzaWQiOiIwNGFkMzM4ZS1lNmI0LTQxNzMtODM5Yy0yMDJiODhmOWY5ZjAiLCJhdF9oYXNoIjoiZ2hBaHE1aWstVElFTUZoeXBxQVRPUSIsImFjciI6IjEiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6Im15IHVzZXIiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJteS11c2VyIiwiZ2l2ZW5fbmFtZSI6Im15IiwiZmFtaWx5X25hbWUiOiJ1c2VyIiwiZW1haWwiOiJteS11c2VyQHRlc3QuY29tIn0.Qpn8pDavyGfVWXc2QB6IXm4-XWQCmUlOHlXiLgS_wp79vRzHkOOnPP8GcWPkRDGqdIym8HRd-sBcJbsr7x9PUpRrk8CkLUEcU-KFZ4Hbzq00ZOEtP62qfjn21n8z5TjhYJW6mBz7h_V82Ab2bZa5_90Bt0V_g59nIaED8tlRfh2-nqmk_eAxMdMT_j9IezR1dPYgs4ym5DvnHFfup2zrhwDPMgX7XCW7dYXAqhtXsYt6bjt8Db0He58Xx6Vfe-lT8MzCs1EG1S6WpFsCEiLbEbEXVl3Ni-olbr9DnKVRNGPvucdRGPo1ILIX2CuMn7Iidm5onkR1-7gi5UVCCkJe6g" \
  "http://keycloak.microservices.svc.cluster.local:80/realms/klight-api-gateway/protocol/openid-connect/token/introspect"
```