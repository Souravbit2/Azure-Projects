**#Creating and Evaluating Azure Application Gateway**

This guide will walk you through the process of setting up an Azure Application Gateway. We'll cover creating two virtual machines, installing IIS on them, deploying an Application Gateway to load balance traffic to these VMs, and finally, evaluating its functionality.
1. Prerequisites: Create Azure Virtual Machines
First, we need two Windows Server virtual machines to act as our backend web servers.
	1. Log in to Azure Portal: Go to portal.azure.com.
	2. Create Resource Group:
		○ Click Resource groups > + Create.
		○ Provide a Resource group name (e.g., AppGatewayRG).
		○ Choose a Region (e.g., East US).
Click Review + create > Create.
	3. Create Virtual Network:
		○ Click Virtual networks > + Create.
		○ Select your Resource Group (e.g., AppGatewayRG).
		○ Provide a Virtual network name (e.g., AppGatewayVNet).
		○ Choose the same Region as your resource group.
		○ Under IP Addresses, keep the default address space (e.g., 10.0.0.0/16).
		○ Add two subnets:
			§ One for your VMs: + Add subnet > Name: BackendSubnet, Address range: 10.0.1.0/24.
			§ One for the Application Gateway (it requires its own dedicated subnet): + Add subnet > Name: AppGatewaySubnet, Address range: 10.0.0.0/24.
Click Review + create > Create.

<img width="1301" height="305" alt="image" src="https://github.com/user-attachments/assets/4f9a98dc-d1ca-4f24-87f9-01f2ef3187f6" />

4. Create Virtual Machine 1 (VM1):
  ○ Click Virtual machines > + Create > Azure virtual machine.
  ○ Basics tab:
    § Resource group: AppGatewayRG
    § Virtual machine name: WebAppVM1
    § Region: Same as your resource group.
    § Image: Windows Server 2019 Datacenter (or similar).
    § Size: Choose a suitable size (e.g., Standard_B2s).
    § Username and Password: Create credentials for RDP access.
    § Public inbound ports: None (we'll use the Application Gateway for external access).
  ○ Disks tab: Keep defaults.
  ○ Networking tab:
    § Virtual network: AppGatewayVNet
    § Subnet: BackendSubnet
    § Public IP: None (we don't need direct public access to the VMs).
    § NIC network security group: Basic (or create a custom one if needed).
    § Delete public IP and NIC when VM is deleted: Check this box.
  ○ Management, Advanced, Tags tabs: Keep defaults or configure as needed.
  ○ Click Review + create > Create.
5. Create Virtual Machine 2 (VM2):
  Repeat step 4, but name it WebAppVM2. Ensure it's in the same Resource Group, Virtual network (AppGatewayVNet), and Subnet (BackendSubnet).

<img width="1302" height="339" alt="image" src="https://github.com/user-attachments/assets/b77cdea1-c572-4947-88d4-b51fd69be70b" />

2. Install IIS on Virtual Machines
Now, let's install IIS on both WebAppVM1 and WebAppVM2 and create a simple test page.
	1. Connect to WebAppVM1 via RDP:
		○ In the Azure portal, navigate to Virtual machines > WebAppVM1.
		○ Click Connect > RDP > Download RDP File.
		○ Open the downloaded file and connect using the username and password you set during VM creation.
	2. Install IIS on WebAppVM1:
		○ Once connected, open Server Manager.
		○ Click Add roles and features.
		○ Click Next until you reach Server Roles.
		○ Check Web Server (IIS).
		○ Click Add Features in the pop-up.
		○ Click Next until Confirmation, then click Install.
		○ Wait for the installation to complete, then click Close.
	3. Create a Test HTML Page on WebAppVM1:
		○ Open File Explorer and navigate to C:\inetpub\wwwroot.
		○ Right-click in the folder, select New > Text Document.
		○ Name it index.html.
		○ Open index.html with Notepad and add the following content:
<!DOCTYPE html>
<html>
<head>
    <title>Web App VM1</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f0f8ff; color: #333; text-align: center; padding-top: 50px; }
        h1 { color: #4682b4; }
        p { font-size: 1.2em; }
    </style>
</head>
<body>
    <h1>Hello from WebAppVM1!</h1>
    <p>This page is served by the first virtual machine.</p>
</body>
</html>
		○ Save the file.
	4. Repeat for WebAppVM2:
		○ Connect to WebAppVM2 via RDP.
		○ Install IIS on WebAppVM2 using Server Manager (same steps as for VM1).
		○ Create C:\inetpub\wwwroot\index.html on WebAppVM2 with the following content:
<!DOCTYPE html>
<html>
<head>
    <title>Web App VM2</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #fffafa; color: #333; text-align: center; padding-top: 50px; }
        h1 { color: #dc143c; }
        p { font-size: 1.2em; }
    </style>
</head>
<body>
    <h1>Hello from WebAppVM2!</h1>
    <p>This page is served by the second virtual machine.</p>
</body>
</html>
Save the file.

<img width="968" height="434" alt="image" src="https://github.com/user-attachments/assets/194e0f84-3b46-4da8-9d69-5c70d30e7d8a" />

<img width="978" height="551" alt="image" src="https://github.com/user-attachments/assets/0633f8e4-217a-4c7b-8bb2-dc20bdde5e87" />
3. Establish an Application Gateway
Now, let's create the Application Gateway and configure it to direct traffic to our IIS servers.
	1. Create Application Gateway Resource:
		○ In the Azure portal, search for Application Gateway and select it.
		○ Click + Create.
		○ Basics tab:
			§ Resource group: AppGatewayRG
			§ Application gateway name: MyWebAppGateway
			§ Region: Same as your resource group.
			§ Tier: Standard V2 (recommended for production, offers more features and better performance).
			§ Enable autoscaling: Yes (recommended for dynamic traffic).
			§ Minimum instance count: 1
			§ Maximum instance count: 2 (or adjust based on expected load).
			§ Availability zone: None (or select zones for higher availability).
			§ HTTP2: Disabled (unless you specifically need it).
		○ Frontends tab:
			§ Frontend IP address type: Public
			§ Public IP address: + Add new
				□ Public IP address name: MyAppGatewayPublicIP
				□ Click OK.
		○ Backend pools tab:
			§ + Add a backend pool
				□ Backend pool name: MyBackendPool
				□ Target type: Virtual machine
				□ Target: Select WebAppVM1 and WebAppVM2 from the dropdown.
				□ Click Add.
		○ Configuration tab:
			§ Click + Add a routing rule.
			§ Rule name: MyRoutingRule
			§ Listener tab:
				□ Listener name: MyHttpListener
				□ Frontend IP: Public
				□ Protocol: HTTP (for this example, you'd use HTTPS for production).
				□ Port: 80
			§ Backend targets tab:
				□ Target type: Backend pool
				□ Backend target: MyBackendPool
				□ HTTP settings: + Add new
					® HTTP settings name: MyHttpSettings
					® Backend protocol: HTTP
					® Backend port: 80
					® Cookie-based affinity: Disabled (for simple load balancing, enable for sticky sessions).
					® Health probe: + Add new
						◊ Name: MyHealthProbe
						◊ Protocol: HTTP
						◊ Host: 127.0.0.1 (or your VM's private IP if you have a specific host header)
						◊ Path: / (or /index.html if you want to be specific)
						◊ Interval (seconds): 30
						◊ Threshold (unsuccessful probes): 3
						◊ Timeout (seconds): 30
						◊ Click Add.
					® Click Add for HTTP settings.
			§ Click Add for the routing rule.
		○ Tags tab: (Optional) Add tags.
		○ Click Review + create.
Wait for validation to pass, then click Create. This process can take 10-15 minutes.

<img width="1295" height="554" alt="image" src="https://github.com/user-attachments/assets/febe1bab-3e51-4f18-9c7a-e988957da345" />

4. Application Gateway Evaluation
Once your Application Gateway is deployed, it's time to test and evaluate its functionality.
	1. Get Application Gateway Public IP:
		○ In the Azure portal, navigate to Application Gateways > MyWebAppGateway.
		○ On the Overview page, locate the Frontend public IP address. Copy this IP address.
	2. Test Basic Connectivity and Load Balancing:
		○ Open a web browser and paste the copied public IP address.
		○ You should see either "Hello from WebAppVM1!" or "Hello from WebAppVM2!".
Refresh the page multiple times (Ctrl+F5 or Cmd+R). You should observe the page alternating between the content from WebAppVM1 and WebAppVM2, demonstrating that the Application Gateway is successfully load balancing traffic.

<img width="495" height="269" alt="image" src="https://github.com/user-attachments/assets/966c0106-c6fc-4546-bf41-fb288757e67b" />


<img width="583" height="283" alt="image" src="https://github.com/user-attachments/assets/fe3097c2-4184-4430-ad67-2e45c27fd77e" />

3. Verify Health Probes:
      ○ In the Azure portal, navigate to Application Gateways > MyWebAppGateway.
      ○ Go to Backend health under Monitoring.
      ○ You should see MyBackendPool with both WebAppVM1 and WebAppVM2 showing Healthy status.
      ○ Test Health Probe Failure:
        § Connect to WebAppVM1 via RDP.
        § Stop the World Wide Web Publishing Service (W3SVC) in Services (search for services.msc).
        § Go back to the Azure portal and refresh the Backend health page for your Application Gateway. After a minute or two, WebAppVM1 should show Unhealthy.
        § Continue refreshing your web browser (using the Application Gateway's public IP). You should now only see "Hello from WebAppVM2!" because the Application Gateway has detected WebAppVM1 as unhealthy and stopped sending traffic to it.
        § Start the World Wide Web Publishing Service on WebAppVM1 again. After a few minutes, it should return to Healthy status, and traffic will resume being sent to it.
    4. Monitor Metrics:
    		○ In the Azure portal, navigate to Application Gateways > MyWebAppGateway.
    		○ Go to Metrics under Monitoring.
    		○ Explore various metrics like:
    			§ Throughput: Shows the data transferred through the gateway.
    			§ Total Requests: Number of requests processed.
    			§ Backend Health Status: Provides a visual trend of backend health.
    			§ Unhealthy Host Count: Number of unhealthy backend instances.
    			§ HTTP Status Code: Breakdown of HTTP response codes (2xx, 3xx, 4xx, 5xx).
These metrics are crucial for understanding the performance and health of your application.










