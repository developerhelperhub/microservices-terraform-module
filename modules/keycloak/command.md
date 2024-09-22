```shell
kubectl logs <pod-name> -n <namespace> --tail=100
```

Resource Limits and Node Disk Space
If there's insufficient disk space on your Kubernetes nodes, the image pull process could fail or time out. You can check node disk space using the following command:

```shell
kubectl describe nodes | grep -A10 "Non-terminated"
```

**Login into postgresql**
```shell
kubectl -n microservices exec -it pod/keycloak-postgresql-0 -- psql -U keycloak -d keycloakdb
```

# login keyloack container and testing psql connection
```shell
kubectl exec -it <keycloak-pod-name> -n <namespace> -- bash
# Inside the pod, try to ping the database:
ping <database-host>  # Replace with your DB host name or IP

# You can also try using curl to check the database service
curl http://<database-host>:<database-port>  # Test connection to DB port
```

