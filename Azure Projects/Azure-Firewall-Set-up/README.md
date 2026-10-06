# Azure-Firewall-Set-up

Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall-as-a-service with built-in high availability and unrestricted cloud scalability.

Here's a breakdown of how to create an Azure Firewall and configure it for your specified requirements:

## 1. Firewall and Policy Deployment

Azure Firewall uses a **Firewall Policy** to manage its rule sets. This is the recommended and more flexible approach compared to classic rules.

**Prerequisites:**

* **Azure Subscription:** You'll need an active Azure subscription.
* **Virtual Network (VNet):** You'll need a virtual network where your firewall will reside, and other VNets (spoke VNets) if you're deploying a hub-and-spoke topology (a common and recommended practice).
* **Dedicated Subnet for Firewall:** Within your VNet, you'll need a dedicated subnet named **AzureFirewallSubnet**. This subnet must be at least a /26 size.

**Steps to Deploy Azure Firewall and Policy (using Azure Portal):**

1.  **Create a Resource Group:**
    * Sign in to the Azure portal.
    * Search for "Resource groups" and select it.
    * Click "Create".
    * Provide a **Subscription**, **Resource group name** (e.g., `fweastus`), and **Region**. This region should be the same for all related resources.
    * Review and Create.

<img width="1270" height="592" alt="image" src="https://github.com/user-attachments/assets/5bb87331-6a3c-41c5-b439-08796afee5a5" />



2.  **Create a Virtual Network (if you don't have one):**
    * From the portal, search for "Virtual networks" and select it.
    * Click "Create".
    * Select your **Subscription** and the **Resource group** you just created.
    * Provide a **Name** for your VNet (e.g., `fwvnet`).
    * Choose the same **Region** as your resource group.
    * Configure address space (e.g., `10.0.0.0/16`).
    * On the "Security" tab, you can enable Azure Firewall here, or deploy it separately as shown in the next steps.
    * Review and Create.

<img width="1736" height="431" alt="image" src="https://github.com/user-attachments/assets/ecb7e801-3fac-440e-8d48-2e0588eb0d5a" />

3.  **Create the AzureFirewallSubnet:**
    * Navigate to your newly created VNet (`fwvnet`).
    * Under "Settings", select "Subnets".
    * Click "+ Subnet".
    * For **Subnet name**, type `AzureFirewallSubnet`.
    * For **Subnet address range**, use a /26 range (e.g., `10.0.1.0/24 or /26`).
    * Click "Save".

<img width="1855" height="386" alt="image" src="https://github.com/user-attachments/assets/8f6ed328-c5b7-4bec-a655-204409b13a01" />

4.  **Deploy Azure Firewall and Firewall Policy:**
    * From the Azure portal, search for "Firewall" and select it.
    * Click "Create".
    * On the "Create a Firewall" page:
        * **Subscription** and **Resource group**: Select your subscription and the resource group (`fweastus`).
        * **Firewall name**: Give your firewall a name (e.g., `fw`).
        * **Region**: Select the same region.
        * **Firewall tier**: Choose "Standard" or "Premium" (Premium offers advanced features like TLS Inspection, IDPS, and URL Filtering).
        * **Firewall management**: Select "Use a Firewall Policy to manage this firewall" (recommended).
        * **Firewall Policy**: Click "Add new" and provide a **Name** for your policy (e.g., `myfwpolicy`). Choose the same region.
        * **Choose a virtual network**: Select "Use existing" and choose your VNet (`fwvnet`). The `AzureFirewallSubnet` should be automatically selected.
        * **Public IP address**: Click "Add new" and provide a **Name** for the Public IP (e.g., `fw-pip`).
    * Click "Review + create" and then "Create". This deployment may take a few minutes.

<img width="1780" height="388" alt="image" src="https://github.com/user-attachments/assets/c158614e-926f-442e-a631-7683caf70e17" />

## 2. Establish a Default Route (User-Defined Route - UDR)

For traffic from your workloads (VMs in other subnets/VNets) to flow through the Azure Firewall for inspection, you need to create a **User-Defined Route (UDR)**. This UDR will direct all outbound traffic (`0.0.0.0/0`) from your workload subnets to the private IP address of the Azure Firewall.

**Steps to Create a Default Route:**

1.  **Note the Azure Firewall Private IP Address:**
    * After the firewall deployment completes, go to your deployed Azure Firewall resource (`fw`).
    * On the "Overview" page, note down the **Private IP address** of the firewall.

<img width="1188" height="405" alt="image" src="https://github.com/user-attachments/assets/486937ad-5f9d-4260-9a14-d09ec802c846" />

2.  **Create a Route Table:**
    * From the Azure portal, search for "Route tables" and select it.
    * Click "Create".
    * Provide **Subscription**, **Resource group** (`fwEastus`), **Region**, and a **Name** (e.g., `Firewall-RouteTable`).
    * Review and Create.

<img width="1182" height="249" alt="image" src="https://github.com/user-attachments/assets/c2ba5481-8486-43bf-bc17-58786fdf39dc" />

3.  **Add the Default Route to the Route Table:**
    * Once the route table is deployed, go to the `Firewall-RouteTable` resource.
    * Under "Settings", select "Routes".
    * Click "+ Add".
    * For **Route name**, type `fw-dg` (firewall default gateway).
    * For **Destination type**, select "IP Addresses".
    * For **Destination IP addresses/CIDR ranges**, type `0.0.0.0/0`.
    * For **Next hop type**, select "Virtual appliance".
    * For **Next hop address**, enter the **Private IP address** of your Azure Firewall that you noted earlier.
    * Click "Add".

<img width="1304" height="452" alt="image" src="https://github.com/user-attachments/assets/d3f1bbf3-a25f-4512-9883-762a065de798" />

4.  **Associate the Route Table with Workload Subnets:**
    * From the `Firewall-RouteTable` resource, under "Settings", select "Subnets".
    * Click "+ Associate".
    * For **Virtual network**, select the VNet where your workload VMs reside (e.g., `Test-FW-VN`).
    * For **Subnet**, select the specific subnet(s) where your VMs are located that need to route traffic through the firewall (e.g., `Workload-SN`).
    * Click "OK".

<img width="1278" height="561" alt="image" src="https://github.com/user-attachments/assets/070e8d8f-9060-435c-80df-2a3bab96f6cc" />

<img width="1287" height="520" alt="image" src="https://github.com/user-attachments/assets/d9f1e728-b2db-49ed-9a22-4af13bd78e6c" />


 **Important:** Do NOT associate this route table with the `AzureFirewallSubnet`. Doing so will break the firewall's functionality.

## 3. Create a Rule for the Application

Azure Firewall policies use **Rule Collections** and **Rules** to control traffic. There are three types of rules:

* **DNAT Rules:** For inbound traffic to translate public IP to private IP.
* **Network Rules:** For filtering traffic based on IP addresses, ports, and protocols (TCP, UDP, ICMP, Any). Processed before application rules.
* **Application Rules:** For filtering traffic based on Fully Qualified Domain Names (FQDNs), URLs, and HTTP/HTTPS protocols. Processed after network rules if no network rule matches and the protocol is HTTP/HTTPS/MSSQL.

Let's create an example **Application Rule** to allow outbound access to a specific FQDN.

**Steps to Create an Application Rule:**

1.  **Navigate to your Firewall Policy:**
    * From your Azure Firewall resource (`fw`), click on the "Firewall Policy" link in the "Overview" blade (or search for "Firewall policies" and select `MyFWPolicy`).

2.  **Create an Application Rule Collection:**
    * On the Firewall Policy page, under "Settings", select "Application Rules".
    * Click "Add a rule collection".
    * **Name**: Give your rule collection a name (e.g., `AllowOutboundApps`).
    * **Priority**: A number between 100 (highest) and 65000 (lowest). Lower numbers are processed first. Leave some gaps (e.g., 200, 300) for future rules.
    * **Rule collection group**: You can use the default "Default Application Rule Collection Group" or create a custom one.
    * **Action**: Select "Allow".

3.  **Add an Application Rule:**
    * Within the "Add Application Rule Collection" blade, under "Rules", click "+ Add rule".
    * **Name**: Give the rule a name (e.g., `AllowMicrosoftDocs`).
    * **Source type**: Select "IP Address".
    * **Source**: Enter the IP address range of your workload subnet (e.g., `10.0.2.0/24`). You can also use `*` for all sources, but it's less secure.
    * **Protocol:Port**: `http, https`. If using TLS Inspection (Premium SKU), you can also add `https`.
    * **Target FQDNs**: Enter the FQDN you want to allow (e.g., `*.microsoft.com`). You can use wildcards.
    * **TLS inspection**: If you have a Premium SKU and want to inspect HTTPS traffic, enable this and ensure you have the necessary certificates configured.
    * Click "Add".
    * Click "Add" again to create the rule collection.

**Rule Processing Logic Summary:**

* **DNAT Rules** are processed first. If a match is found, traffic is translated and allowed, and no further rules are processed.
* **Network Rules** are processed next. If a match is found, the action (allow/deny) is taken, and no further rules are processed.
* **Application Rules** are processed if no network rule matches and the protocol is HTTP, HTTPS, or MSSQL.
* If no rule matches, the traffic is **denied by default**.

## 4. Test VM connecting to Firewall Set up
   Most of the windows based VMs have their RDP traffic flow through the port 3389 hence the port needs to be open in NSG as well as we'll have to create a DNAT port based rule under firewall policy to ensure the firewall allows traffic coming to the same port from public internet. without this rule set up , the firewall by default blocks RDP traffic both ways, so it's very crucial that we create this.

1. Create a DNAT Rule in Azure Firewall
To allow RDP traffic from the internet to your VM:
- Go to Azure Firewall > Rules > NAT Rule Collection
- Add a DNAT rule:
- Source: * (or restrict to specific public IPs)
- Destination: Public IP of the Azure Firewall
- Destination Port: Custom port (e.g., 50001)
- Translated Address: Private IP of the VM
- Translated Port: 3389 (default RDP port)
This forwards RDP traffic from the firewall’s public IP to your VM.
<img width="1304" height="378" alt="image" src="https://github.com/user-attachments/assets/1c0672b8-b081-4cc1-bb24-d3c12646d3ee" />
<img width="1299" height="412" alt="image" src="https://github.com/user-attachments/assets/b9ecb145-1f84-4aa8-b8f4-a0019bd75c4e" />

🔁 2. Update Route Table
Ensure traffic flows through the firewall:
- Create a Route Table
- Add a route:
- Address Prefix: 0.0.0.0/0
- Next Hop Type: Virtual appliance
- Next Hop IP: Private IP of Azure Firewall
- Associate this route table with the VM’s subnet.

🔒 3. Check NSG and Guest OS Firewall
- Network Security Group (NSG):
- Allow inbound traffic on port 3389 from the firewall’s IP or your public IP.
- Windows Firewall on VM:
- Ensure RDP is allowed.
- You can run this command via Serial Console or recovery VM:
netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes

🧠 Pro Tip
**Avoid asymmetric routing by ensuring all traffic (inbound and outbound) flows through the firewall. If you’ve set up a route to the firewall, you can’t RDP directly to the VM’s public IP.**
Once you've created the DNAT rule and updated the route table to route traffic through Azure Firewall, here's how you should RDP into your VM:

## 5. Test VM RDP connectivity
   🖥️ Use the Firewall’s Public IP + Custom Port
   You **must not** use the VM’s public IP anymore—due to asymmetric routing, it won’t work. Instead:
   
   - Open **Remote Desktop Connection** on your local machine
   - In the **Computer** field, enter:
     ```
     <Firewall_Public_IP>:<Custom_Port>
     ```
     For example:
     ```
     20.45.123.10:50001
     ```
     - `20.45.123.10` → Public IP of Azure Firewall
     - `50001` → The destination port you configured in the DNAT rule
   
   This tells RDP to connect to the firewall, which then forwards the traffic to your VM’s private IP on port 3389.

   ---
   
   ### 🔐 Credentials & Access
   - Use the **VM’s local admin credentials** to log in.
   - Make sure the VM’s **Windows Firewall** allows RDP.
   - NSG should allow inbound traffic on port 3389 from the firewall.
   
   
   ### 🧪 Test It
   You can test connectivity using PowerShell:
   ```powershell
   Test-NetConnection -ComputerName <Firewall_Public_IP> -Port <Custom_Port>
   ```
   
   If it succeeds, you're good to go!


**Key Considerations:**

* **DNS Configuration:** Ensure your VMs use a DNS server that can resolve the FQDNs specified in your application rules. You might need to configure custom DNS servers in your VNet or on the VM's network interface, pointing to public DNS servers or your own DNS server that the firewall can reach.
* **Network Security Groups (NSGs):** While Azure Firewall provides centralized security, NSGs can still be used for granular control within subnets (e.g., restricting VM-to-VM communication within a subnet or inbound access to specific ports). However, ensure NSG rules don't conflict with or inadvertently block traffic intended for the firewall. If traffic is forced through the firewall via a UDR, the source IP for application rules might become the firewall's private IP, which needs to be considered in NSG rules.
* **Logging and Monitoring:** Enable Azure Firewall diagnostics settings to send logs to a Log Analytics workspace or storage account. This is crucial for monitoring traffic, troubleshooting, and auditing.
* **Hub and Spoke Topology:** For more complex environments, a hub-and-spoke topology is often used. The Azure Firewall resides in the hub VNet, and other VNets (spokes) are peered to the hub. UDRs in the spoke VNets direct all outbound traffic to the firewall in the hub.
* **Forced Tunneling:** If you need to force all internet-bound traffic through an on-premises firewall, Azure Firewall supports forced tunneling. This requires careful configuration of routes.

By following these steps, you can successfully deploy an Azure Firewall, establish a default route to direct traffic through it, and create application rules to control outbound connectivity.
