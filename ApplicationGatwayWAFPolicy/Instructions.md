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