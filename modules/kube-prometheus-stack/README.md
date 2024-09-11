# kube-prometheus-stack

This is a comprehensive Helm chart that deploys a full monitoring solution based on the Kube-Prometheus project. It integrates Prometheus, Alertmanager, and Grafana, along with various Kubernetes-specific exporters and monitoring configurations.

Components:
Prometheus: For collecting and storing metrics.
Alertmanager: For handling alerts.
Grafana: A visualization tool for creating dashboards using the collected metrics.
Prometheus Operator: Manages and simplifies the deployment and configuration of Prometheus and Alertmanager instances.
Kube-State-Metrics: Generates metrics about the state of Kubernetes objects.
Node Exporter: Collects hardware and OS metrics from Kubernetes nodes.
Prometheus Adapter: For Kubernetes custom metrics API, useful for Horizontal Pod Autoscaling (HPA).
Additional Exporters: Such as the kubelet, etcd, cAdvisor, and API server metrics exporters.

Use Case: Ideal for users who want a turnkey monitoring solution for their Kubernetes cluster. It is designed for Kubernetes and provides an out-of-the-box setup that integrates well with the Kubernetes ecosystem, supporting various monitoring needs right away. It is often preferred for new Kubernetes deployments where a comprehensive monitoring solution is required.

Customization: Offers a high level of customization through Helm values. You can enable or disable components and configure them to fit specific use cases. This chart also automatically sets up various Grafana dashboards for visualizing Kubernetes metrics, saving time in setting up complex dashboards manually.

Get list of helm chart installed
```shell
helm list -A
```
Uninstall
```shell
helm uninstall kube-prometheus-stack --namespace microservices
```

## Reference
* (kube-prometheus-stack)[https://medium.com/@CloudTopG/how-to-install-prometheus-and-grafana-on-your-cluster-using-terraform-and-helm-f74c3dff3c]
* (Helm Value)[https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml]