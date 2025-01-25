### Relam Configuration
Keycloak supports multi-tenancy, enabling us to create application-specific configurations through realm setup. For the `Klight API Gateway`, we maintain a dedicated realm.

* Login into Keyloak server `http://keycloak.myapp.com/`
* Click on the "Keycloak master" realm in the left corner.
* Click the "Create realm" button.
* Enter the realm name as "klight-api-gateway"
* Enable the realm by toggling the "Enabled" option.
* Click the "Create" button.

### Relam Setting
We have to check the frontend URL of Keycloak, while authenticating Keycloak should us the "keycloak.myapp.com" domain in the browser, otherwise it will be used Kubernetes domain such as "http://keycloak.microservices.svc.cluster.local"

* Click on Relam Setting 
* Add the Frontend URL into "http://keycloak.myapp.com"
* Click save button

**Note**: Ensure that the "klight-api-gateway" realm is selected before configuring anything, as the default realm is set to "master."

