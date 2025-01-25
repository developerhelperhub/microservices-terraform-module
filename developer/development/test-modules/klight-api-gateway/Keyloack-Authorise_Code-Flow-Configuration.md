### Introspection Flow Configuration
We have to follow the below configurations for setuping the introspection flow in the Keycloak.

#### Create the client
Create client is `klight-api-gateway-openid-connect-authorize-code` this is support OpenID connection where API Gateway can connect the Keycloak server through this client

* Click "Client" in the left sidebar menu
* Click "Create Client" button
* Configure the following "General Setting"
  * Select the client type is "OpenID Connect"
  * Enter the Clent Id: "klight-api-gateway-openid-connect-authorize-code"
  * Enter the Client name: "Klight API Gateway OpenID Connect"
  * Click "Next" button
* Configure the following "Capability config"
  * Enable the "Client authentiction" is On
  * Enable the "Authorization" is On
  * Select only "Standard Flow grants" flow, This option helps to more secure when we have public access client instead of introspection flow
  * Click "Next" button
* Configure the following "Login settings"
  * Enter the "Web origins" is "http://api.gateway.mes.app.com"
  * Enter the "Valid redirect URIs" is "http://api.gateway.mes.app.com/oauth2/callback"
* Click "Save" button
* Select "Credentials" tab once created the client
  * Select the "Client Authenticator" is "Client Id and Secret"
  * Click "Generate" new "Client Secret"


#### Create the user
In this flow, we have to create a new user authenticate the server
* Click "Users" in the left sidebar menu
* Click "Create new user" button
* Enabled the "Email verfied" is "On"
* Enter the "General" information
  * Username : "my-user"
  * Email : "my-user@test.com"
  * Firstname : "my"
  * Lastname : "user"
* Click the "Create" button
* Click the "Credentials" tab
  * Click the "Set password" button
  * Entered the "Password and "Password confirmation" is "test"
  * Disabled the "Temporary" is Off
  * Click "Save" button
  * Click the "Save password"

Note: if we are not set the email, first name and last name, while get token, we will get error "Account is not fully set up [invalid_grant]

#### Get the token from the Keycloack server
We are testing the this flow in the browser, this flow redirect to Keycloak site to authenticate the username and password first. 
Open Brower and enter our API Gateway endpoint. 
```shell
http://api.gateway.mes.app.com/oauth2/authoirse
```
It will redirect to Keycloak login screen where we have to enter the username and password. Enther username and password which we have created in the user section
```shell
username: "my-user"
password: "test"
```
Keycloak redirect "/callback" API in the API gateway once successfully authenticated. The API geteway validate the request with session information as part of "/callback" URL and return the token information. Following response we are able to see in the browser
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIi",
  "refresh_token": "eyJhbGciOiJIUzUxMiIsInR5cCIgOiAiSldUIiwia2lkIiA6I",
  "id_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJP",
  "access_token_expiration": 1735469972
}
```

Execute the following command of endpoint of API Gateway
```shell
curl --location 'http://api.gateway.mes.app.com/item-service/items' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJP'
```
Response 
```json
{"items":[{"id":"100001","name":"Item 1"},{"id":"100002","name":"Item 2"}]}
```
