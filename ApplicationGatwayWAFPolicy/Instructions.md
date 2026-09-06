# Application Gateway with WAF

This guide deploys:

`Client -> Application Gateway WAF v2 -> Azure Function App -> Storage Account`

The commands use Azure CLI. Run them from Azure Cloud Shell or a shell with the Azure CLI installed. Replace every value in the configuration block before running the commands.

## 0. Configure variables

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"

export LOCATION="eastus"
export RESOURCE_GROUP="mylab"
export VNET_NAME="vnet-appgw-waf"
export APPGW_SUBNET="snet-appgw"
export PRIVATE_ENDPOINT_SUBNET="snet-private-endpoints"
export PUBLIC_IP_NAME="pip-appgw-waf"
export WAF_POLICY_NAME="waf-policy"
export APPGW_NAME="appgw-waf"
export FUNCTION_APP_NAME="myfunctionapp1234"
export FUNCTION_HOST="${FUNCTION_APP_NAME}.azurewebsites.net"
export STORAGE_ACCOUNT_NAME="mysg1234"
export USER_ASSIGNED_IDENTITY="myuseridentity123"
export DOMAIN_NAME="api.example.com"
```

Verify the selected subscription:

```bash
az account show --query "{subscription:id,tenant:tenantId}" -o table
```

## 1. Create the resource group

```bash
az group create \
   --name "$RESOURCE_GROUP" \
   --location "$LOCATION"
```

## 2. Create the VNet and subnets

The Application Gateway subnet must be dedicated to Application Gateway instances.

```bash
az network vnet create \
   --resource-group "$RESOURCE_GROUP" \
   --name "$VNET_NAME" \
   --location "$LOCATION" \
   --address-prefix 10.20.0.0/16 \
   --subnet-name "$APPGW_SUBNET" \
   --subnet-prefix 10.20.0.0/24

az network vnet subnet create \
   --resource-group "$RESOURCE_GROUP" \
   --vnet-name "$VNET_NAME" \
   --name "$PRIVATE_ENDPOINT_SUBNET" \
   --address-prefixes 10.20.1.0/24 \
   --private-endpoint-network-policies Disabled
```

## 3. Prepare the Function App and managed identity

Deploy the Function App using the Azure Functions extension, Core Tools, or your existing CI/CD pipeline. Then configure its storage URL:

```bash
export STORAGE_ACCOUNT_URL="https://${STORAGE_ACCOUNT_NAME}.blob.core.windows.net"

az functionapp config appsettings set \
   --resource-group "$RESOURCE_GROUP" \
   --name "$FUNCTION_APP_NAME" \
   --settings STORAGE_ACCOUNT_URL="$STORAGE_ACCOUNT_URL"
```

Assign the existing user-assigned identity to the Function App:

```bash
export IDENTITY_RESOURCE_ID=$(az identity show \
   --resource-group "$RESOURCE_GROUP" \
   --name "$USER_ASSIGNED_IDENTITY" \
   --query id -o tsv)

az functionapp identity assign \
   --resource-group "$RESOURCE_GROUP" \
   --name "$FUNCTION_APP_NAME" \
   --identities "$IDENTITY_RESOURCE_ID"
```

Grant the identity read access to blobs:

```bash
export IDENTITY_PRINCIPAL_ID=$(az identity show \
   --ids "$IDENTITY_RESOURCE_ID" \
   --query principalId -o tsv)

export STORAGE_RESOURCE_ID=$(az storage account show \
   --resource-group "$RESOURCE_GROUP" \
   --name "$STORAGE_ACCOUNT_NAME" \
   --query id -o tsv)

az role assignment create \
   --assignee-object-id "$IDENTITY_PRINCIPAL_ID" \
   --assignee-principal-type ServicePrincipal \
   --role "Storage Blob Data Reader" \
   --scope "$STORAGE_RESOURCE_ID"
```

## 4. Create the WAF policy

Start in Detection mode. Review the logs before switching to Prevention.

```bash
az network application-gateway waf-policy create \
   --resource-group "$RESOURCE_GROUP" \
   --name "$WAF_POLICY_NAME" \
   --location "$LOCATION" \
   --type OWASP \
   --version 3.2 \
   --mode Detection

az network application-gateway waf-policy policy-setting update \
   --resource-group "$RESOURCE_GROUP" \
   --policy-name "$WAF_POLICY_NAME" \
   --mode Detection \
   --state Enabled
```

After testing:

```bash
az network application-gateway waf-policy policy-setting update \
   --resource-group "$RESOURCE_GROUP" \
   --policy-name "$WAF_POLICY_NAME" \
   --mode Prevention \
   --state Enabled
```

Do not add exclusions until a WAF log confirms a false positive. Keep exclusions as narrow as possible.

## 5. Create the public IP and Application Gateway

This creates an autoscaling WAF v2 gateway. The initial listener is HTTP so that backend routing can be tested before a certificate is available.

```bash
az network public-ip create \
   --resource-group "$RESOURCE_GROUP" \
   --name "$PUBLIC_IP_NAME" \
   --location "$LOCATION" \
   --allocation-method Static \
   --sku Standard

export WAF_POLICY_ID=$(az network application-gateway waf-policy show \
   --resource-group "$RESOURCE_GROUP" \
   --name "$WAF_POLICY_NAME" \
   --query id -o tsv)

az network application-gateway create \
   --resource-group "$RESOURCE_GROUP" \
   --name "$APPGW_NAME" \
   --location "$LOCATION" \
   --sku WAF_v2 \
   --min-capacity 1 \
   --max-capacity 3 \
   --vnet-name "$VNET_NAME" \
   --subnet "$APPGW_SUBNET" \
   --public-ip-address "$PUBLIC_IP_NAME" \
   --frontend-port 80 \
   --http-settings-port 443 \
   --http-settings-protocol Https \
   --backend-pool-name function-backend \
   --servers "$FUNCTION_HOST" \
   --waf-policy "$WAF_POLICY_ID" \
   --priority 100
```

## 6. Configure the HTTPS backend and host name

The Function App requires its original host name in the backend request. This is important for TLS and App Service host-header routing.

```bash
az network application-gateway http-settings update \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" \
   --name appGatewayBackendHttpSettings \
   --port 443 \
   --protocol Https \
   --host-name "$FUNCTION_HOST" \
   --timeout 30
```

If the generated HTTP setting has a different name, list the settings and substitute the correct name:

```bash
az network application-gateway http-settings list \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" \
   --query "[].name" -o tsv
```

## 7. Configure a health probe

Use a lightweight endpoint that returns HTTP 200 without requiring a user token. A dedicated `/api/health` Function endpoint is recommended.

```bash
az network application-gateway probe create \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" \
   --name function-health \
   --protocol Https \
   --host-name "$FUNCTION_HOST" \
   --path "/api/health" \
   --interval 30 \
   --timeout 10 \
   --threshold 3

az network application-gateway http-settings update \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" \
   --name appGatewayBackendHttpSettings \
   --probe function-health
```

Check backend health:

```bash
az network application-gateway show-backend-health \
   --resource-group "$RESOURCE_GROUP" \
   --name "$APPGW_NAME" \
   -o json
```

## 8. Add HTTPS listener and redirect HTTP to HTTPS

Create a PFX certificate containing the private key. Store it in Key Vault for production. The following command uses a local PFX file for a simple deployment:

```bash
export CERTIFICATE_NAME="api-tls"
export PFX_FILE="./api.example.com.pfx"
export PFX_PASSWORD='<PFX_PASSWORD>'

az network application-gateway ssl-cert create \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" \
   --name "$CERTIFICATE_NAME" \
   --cert-file "$PFX_FILE" \
   --cert-password "$PFX_PASSWORD"
```

Create the HTTPS listener and routing rule in the portal or with CLI after checking the generated component names:

```bash
az network application-gateway frontend-ip list \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" -o table

az network application-gateway frontend-port create \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" \
   --name port-443 \
   --port 443

az network application-gateway frontend-port list \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" -o table
```

In the portal, select **Application Gateway > Listeners > Add listener**, choose the public frontend IP, HTTPS/443, and `$CERTIFICATE_NAME`, then create a basic rule to `function-backend` using `appGatewayBackendHttpSettings`. The exact listener and rule names vary by CLI version and existing gateway configuration.

After the HTTPS rule exists, create the redirect configuration in the portal or use:

```bash
az network application-gateway redirect-config create \
   --resource-group "$RESOURCE_GROUP" \
   --gateway-name "$APPGW_NAME" \
   --name redirect-to-https \
   --type Permanent \
   --include-path true \
   --include-query-string true \
   --target-listener port-443
```

## 9. Restrict direct Function App access

For a private backend, create a private endpoint and private DNS zone. This requires a Function App plan that supports private endpoints.

```bash
az network private-endpoint create \
   --resource-group "$RESOURCE_GROUP" \
   --name pe-function-app \
   --location "$LOCATION" \
   --vnet-name "$VNET_NAME" \
   --subnet "$PRIVATE_ENDPOINT_SUBNET" \
   --private-connection-resource-id "$(az functionapp show --resource-group "$RESOURCE_GROUP" --name "$FUNCTION_APP_NAME" --query id -o tsv)" \
   --group-id sites \
   --connection-name function-private-connection

az network private-dns zone create \
   --resource-group "$RESOURCE_GROUP" \
   --name privatelink.azurewebsites.net

az network private-dns link vnet create \
   --resource-group "$RESOURCE_GROUP" \
   --zone-name privatelink.azurewebsites.net \
   --name function-private-dns-link \
   --virtual-network "$VNET_NAME" \
   --registration-enabled false

az network private-endpoint dns-zone-group create \
   --resource-group "$RESOURCE_GROUP" \
   --endpoint-name pe-function-app \
   --name function-dns-zone-group \
   --private-dns-zone privatelink.azurewebsites.net \
   --zone-name azurewebsites
```

If you keep the Function App public, configure access restrictions and verify that the gateway can still reach the backend before removing public access. Private endpoint access is preferred because Application Gateway cannot be reliably allow-listed using one fixed public source IP in every topology.

## 10. Configure DNS

Get the gateway public IP:

```bash
export APPGW_PUBLIC_IP=$(az network public-ip show \
   --resource-group "$RESOURCE_GROUP" \
   --name "$PUBLIC_IP_NAME" \
   --query ipAddress -o tsv)

echo "$APPGW_PUBLIC_IP"
```

At your DNS provider, create an `A` record:

`api.example.com -> $APPGW_PUBLIC_IP`

For an Azure DNS zone:

```bash
export DNS_ZONE="example.com"

az network dns zone create \
   --resource-group "$RESOURCE_GROUP" \
   --name "$DNS_ZONE"

az network dns record-set a create \
   --resource-group "$RESOURCE_GROUP" \
   --zone-name "$DNS_ZONE" \
   --name api

az network dns record-set a add-record \
   --resource-group "$RESOURCE_GROUP" \
   --zone-name "$DNS_ZONE" \
   --record-set-name api \
   --ipv4-address "$APPGW_PUBLIC_IP"
```

## 11. Enable diagnostics

```bash
export LOG_WORKSPACE="law-appgw-waf"

az monitor log-analytics workspace create \
   --resource-group "$RESOURCE_GROUP" \
   --workspace-name "$LOG_WORKSPACE" \
   --location "$LOCATION"

export WORKSPACE_ID=$(az monitor log-analytics workspace show \
   --resource-group "$RESOURCE_GROUP" \
   --workspace-name "$LOG_WORKSPACE" \
   --query id -o tsv)

az monitor diagnostic-settings create \
   --name appgw-diagnostics \
   --resource "$(az network application-gateway show --resource-group "$RESOURCE_GROUP" --name "$APPGW_NAME" --query id -o tsv)" \
   --workspace "$WORKSPACE_ID" \
   --logs '[{"category":"ApplicationGatewayAccessLog","enabled":true},{"category":"ApplicationGatewayPerformanceLog","enabled":true},{"category":"ApplicationGatewayFirewallLog","enabled":true}]' \
   --metrics '[{"category":"AllMetrics","enabled":true}]'
```

## 12. Test the deployment

```bash
curl -I "https://${DOMAIN_NAME}/api/health"

az network application-gateway show-backend-health \
   --resource-group "$RESOURCE_GROUP" \
   --name "$APPGW_NAME" \
   --query "backendAddressPools[].backendHttpSettingsCollection[].servers" \
   -o json

az monitor log-analytics query \
   --workspace "$WORKSPACE_ID" \
   --analytics-query 'AzureDiagnostics | where ResourceType == "APPLICATIONGATEWAYS" | where Category == "ApplicationGatewayFirewallLog" | sort by TimeGenerated desc | take 20' \
   --out table
```

Verify that normal Function requests succeed, HTTP redirects to HTTPS, suspicious test requests appear in WAF logs, and the Function can still read the blob through its managed identity. Do not return raw exception details from the Function; log the exception internally and return a generic `500` response.
I’ll anchor the guidance to this repository’s Azure projects and check the existing deployment notes so the Application Gateway and WAF steps fit your current setup.



Searched for files matching `**/README.md`, 7 matches

Read , lines 1 to 220

Read 

The repository is centered on Azure Functions and managed identities, so the key design choice is whether the gateway fronts that Function App directly or fronts a private backend through VNet integration. I’m checking the local function shape now, then I’ll give you a concrete deployment sequence and the security settings that matter.

Read 

Read 

For this repository, use this architecture:

`Client -> Application Gateway WAF v2 -> Azure Function App -> Storage Account`

**Recommended Steps**

1. **Create a resource group**
   - Keep the Application Gateway, VNet, WAF policy, and Function App in a clearly managed resource group.

2. **Create a VNet with separate subnets**
   - `ApplicationGatewaySubnet`
   - `FunctionPrivateEndpointSubnet` if using a private Function App
   - Do not place other resources in `ApplicationGatewaySubnet`.

3. **Prepare the Function App**
   - Deploy the Python Function App.
   - Configure `STORAGE_ACCOUNT_URL`.
   - Assign the user-assigned managed identity to the Function App.
   - Grant it `Storage Blob Data Reader` on the storage account.
   - For private backend access, use a Premium/Dedicated plan and create a private endpoint for the Function App.

4. **Create a WAF policy**
   - Use **OWASP CRS 3.2**.
   - Start in **Detection** mode while testing.
   - Move to **Prevention** mode after reviewing Application Gateway WAF logs.
   - Add narrowly scoped exclusions only for confirmed false positives.

5. **Create Application Gateway WAF v2**
   - Choose the existing VNet and `ApplicationGatewaySubnet`.
   - Select a public frontend IP.
   - Use a static public IP.
   - Associate the WAF policy.
   - Enable autoscaling and configure a suitable minimum instance count.

6. **Configure the backend pool**
   - Add the Function App hostname, for example:
     `my-function-app.azurewebsites.net`
   - Use HTTPS on port `443`.
   - Configure the backend HTTP setting to:
     - Use HTTPS
     - Override the host name with the Function App hostname
     - Use an appropriate timeout

7. **Configure the health probe**
   - Probe an endpoint such as `/api/health`.
   - If no health endpoint exists, use the function route, but make sure it does not require an unavailable authentication value.
   - Confirm the probe returns HTTP `200`.

8. **Create the listener and routing rule**
   - Listener: public HTTPS on port `443`.
   - Upload or reference a TLS certificate, preferably from Key Vault.
   - Add a basic routing rule from the listener to the Function backend.
   - Redirect HTTP port `80` to HTTPS.

9. **Secure the Function App**
   - Ideally expose it through a private endpoint and resolve it using a private DNS zone.
   - Alternatively, configure Function App access restrictions so only trusted gateway traffic is accepted.
   - Do not rely on WAF alone to protect a publicly reachable Function hostname.

10. **Configure DNS**
    - Create an `A` or `CNAME` record such as:
      `api.example.com`
    - Point it to the Application Gateway public IP or DNS name.
    - Bind the matching certificate to the HTTPS listener.

11. **Enable monitoring**
    - Send Application Gateway access, performance, and WAF logs to Log Analytics.
    - Enable Function Application Insights.
    - Monitor blocked requests, backend health, latency, and failed probes.

12. **Test**
    - Confirm normal API requests succeed.
    - Test HTTP-to-HTTPS redirection.
    - Test an intentionally suspicious request and verify WAF logging.
    - Stop or restrict the direct Function endpoint and verify the gateway remains the only usable entry point.
    - Confirm the Function can still read the blob using its managed identity.

Before production, change the Function error response in `app.py:17-19` so it does not return raw exception details to callers. Log the exception internally and return a generic `500` response instead.