helm repo add kong https://charts.konghq.com
helm repo update

https://github.com/Kong/charts/blob/main/charts/kong/values.yaml

helm search repo kong/kong
NAME     	CHART VERSION	APP VERSION	DESCRIPTION
kong/kong	2.41.1       	3.6        	The Cloud-Native Ingress and API-management

helm install kong kong/kong --version=2.41.1 -f helm-value.yaml --namespace microservices

helm list -n microservices

helm uninstall kong -n microservices

kubectl cluster-info
docker ps --filter "name=microservices-development-cluster-control-plane" --format "table {{.Names}}\t{{.Ports}}"


kubectl -n microservices exec -it kong-postgresql-0 -- psql -U kong -d kong

kubectl -n microservices get pod 
kubectl -n microservices describe pod kong-postgresql-0
kubectl logs -n microservices  kong-postgresql-0

kubectl -n microservices describe pod kong-kong-86b8f4c695-wws8k
kubectl logs -n microservices  kong-kong-86b8f4c695-wws8k

kubectl exec -it kong-kong-86b8f4c695-wws8k -n microservices -c proxy -- cat /etc/kong/kong.conf.default
