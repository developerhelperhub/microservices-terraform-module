output "keycloak_postgresql_service_name" {
  value = helm_release.keycloak_postgresql[0].metadata[0].name
}