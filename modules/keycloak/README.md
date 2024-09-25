# Keycloak
Keycloak is an open-source identity and access management solution for modern applications and services. It provides features like:

Single Sign-On (SSO): Users can log in once and access multiple applications without having to log in again.
Identity Brokering and Social Login: Keycloak allows authentication through social media platforms or external identity providers (like Google, GitHub, etc.).
User Federation: It can integrate with external user databases (like LDAP or Active Directory).
Centralized Management: Provides a central place to manage users, roles, and access control across applications.
OAuth2 and OpenID Connect Support: Supports modern authentication protocols, allowing secure access to resources.
Multitenancy: Keycloak supports multi-realm environments where each realm can manage its own user base, clients, and roles.
Keycloak is typically used in environments where there’s a need to manage identity, provide secure login, and integrate with various authentication protocols.

**Login into postgresql**
```shell
kubectl -n microservices exec -it pod/keycloak-postgresql-0 -- psql -U keycloak -d keycloakdb
```

## Reference
* (Keycloak install on Kubernetes cluaster)[https://github.com/developerhelperhub/kuberentes-help/tree/main/kubenretes/tutorials/sections/0011]
* (Helm Value)[https://github.com/bitnami/charts/blob/main/bitnami/keycloak/values.yaml]
* (Helm Keycloak example)[https://analytics.axxonet.com/keycloak-deployment-on-kubernetes-with-helm-charts-using-an-external-postgresql-database/]