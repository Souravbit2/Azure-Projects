# VNET-peeing-along-with-VM-connectivity-in-between
Creating two Azure VNets with peering and ensuring communication between VMs involves several steps. Here's a guide:
Guide: VNet Peering with Two VMs
This guide will walk you through setting up two Azure Virtual Networks (VNets), deploying one Virtual Machine (VM) in each VNet, peering them, and then verifying communication.
Estimated Time: 30-45 minutes
Prerequisites:
	• An Azure Subscription
Basic understanding of Azure networking concepts (VNets, Subnets, Network Security Groups)

**Step 1: Create the First VNet and Subnet (vnet1)**

	1. Go to Azure Portal: Log in to portal.azure.com.
	2. Create a Resource Group (Optional but Recommended):
		○ Search for "Resource groups" and click "Create".
		○ Provide a name (e.g., peering).
		○ Select a region (e.g., Central India).
		○ Click "Review + create" and then "Create".
	3. Create Virtual Network:
		○ Search for "Virtual networks" and click "Create".
		○ Basics Tab:
			§ Subscription: Your Azure subscription.
			§ Resource Group: Select the one you just created (peering).
			§ Name: vnet1
			§ Region: Choose the same region as your Resource Group (e.g., Central India).
		○ IP Addresses Tab:
			§ IPv4 address space: 10.0.0.0/16 (This is the address range for your entire VNet).
			§ Add subnet:
				□ Subnet name: subnet1
				□ Subnet address range: 10.0.0.0/24 (This is a smaller range within your VNet for your VMs).
<img width="1280" height="344" alt="image" src="https://github.com/user-attachments/assets/058a04b2-d4c3-4e24-9688-68ad495f1af1" />

<img width="1274" height="541" alt="image" src="https://github.com/user-attachments/assets/67e79748-fb88-4c68-b665-4e53b2f2d8ae" />
**Step 2: Create the Second VNet and Subnet (vnet2)**

	1. Create Virtual Network:
		○ Search for "Virtual networks" and click "Create".
		○ Basics Tab:
			§ Subscription: Your Azure subscription.
			§ Resource Group: Select VNetPeeringRG.
			§ Name: vnet2
			§ Region: Choose the same region as vnet1 (e.g., Central India). It's crucial that VNets for peering are in the same region.
		○ IP Addresses Tab:
			§ IPv4 address space: 10.1.0.0/16 (Important: This must be a non-overlapping address space with vnet1).
			§ Add subnet:
				□ Subnet name:subnet2
	Subnet address range: 10.1.0.0/24
	Security, Tags, Review + create: Leave defaults. Click "Review + create" and then "Create".
<img width="1267" height="296" alt="image" src="https://github.com/user-attachments/assets/dfd16e1c-7c46-4c63-beb8-2c97bcd6bd79" />

<img width="1288" height="294" alt="image" src="https://github.com/user-attachments/assets/47d209e3-6ea8-446f-8659-1f9a779d944d" />
**Step 3: Create a Virtual Machine in vnet1 (peervm1)**

	1. Create Virtual Machine:
		○ Search for "Virtual machines" and click "Create".
		○ Basics Tab:
			§ Subscription: Your Azure subscription.
			§ Resource Group: peering
			§ Virtual machine name: peervm1
			§ Region: East US (same as VNets).
			§ Image: Select an image (e.g., Windows Server 2019 Datacenter or Ubuntu Server 20.04 LTS).
			§ Size: Choose a suitable size (e.g., Standard D2s v3).
			§ Username and Password: Create a username and strong password for administrative access.
			§ Public inbound ports: Select Allow selected ports and RDP (3389) for Windows or SSH (22) for Linux.
		○ Disks Tab: Leave defaults or configure as needed.
		○ Networking Tab:
			§ Virtual network: Select vnet1
			§ Subnet: Select subnet1.
			§ Public IP: (New) peervm1-pip (This allows you to connect to the VM initially).
			§ NIC network security group: Basic.
			§ Public inbound ports: Allow selected ports and confirm RDP (3389) or SSH (22) is selected.
		○ Management, Advanced, Tags, Review + create: Leave defaults. Click "Review + create" and then "Create".
	Wait for deployment: It might take a few minutes for the VM to deploy.
<img width="1119" height="365" alt="image" src="https://github.com/user-attachments/assets/e36472d4-e389-408c-85c2-f74a40050270" />
**Step 4: Create a Virtual Machine in vnet2(peervm2)**

	1. Create Virtual Machine:
		○ Search for "Virtual machines" and click "Create".
		○ Basics Tab:
			§ Subscription: Your Azure subscription.
			§ Resource Group: peering
			§ Virtual machine name: vnet1 
	Region: Central India.
			§ Image: Select the same image as peervm1 for easier testing.
			§ Size: Same as peervm1.
			§ Username and Password: Create a username and strong password.
			§ Public inbound ports: Select Allow selected ports and RDP (3389) for Windows or SSH (22) for Linux.
		○ Disks Tab: Leave defaults.
		○ Networking Tab:
			§ Virtual network: Select vnet2.
			§ Subnet: Select subent2.
			§ Public IP: (New) peervm2-pip.
			§ NIC network security group: Basic.
			§ Public inbound ports: Allow selected ports and confirm RDP (3389) or SSH (22) is selected.
		○ Management, Advanced, Tags, Review + create: Leave defaults. Click "Review + create" and then "Create".
	Wait for deployment: It might take a few minutes for the VM to deploy.
<img width="1153" height="386" alt="image" src="https://github.com/user-attachments/assets/9a933506-b3f0-4bf2-b54e-24e9cb024950" />
**Step 5: Configure VNet Peering**

	VNet peering is bidirectional, meaning you need to create a peering from vnet1 to vnet2, and another peering from vnet2 to vnet1.
		1. Peer from vnet1 to vnet2:
			○ Go to vnet1 (search for "Virtual networks", then click on vnet1).
			○ In the left-hand menu, under Settings, click on Peerings.
			○ Click + Add.
			○ This virtual network: (Leave as vnet1)
				§ Peering link name: vnet1-to-vnet2
			○ Remote virtual network:
				§ Subscription: Your Azure subscription.
				§ Virtual network: Select vnet2.
				§ Peering link name: vnet2-to-vnet1 (This will automatically create the reverse peering).
			○ Allow vnet1 to access vnet2: Ensure "Allow" is selected.
			○ Allow vnet2 to access vnet1: Ensure "Allow" is selected.
			○ Allow forwarded traffic: Leave as "Allow" (important for some advanced scenarios, but generally good to have).
			○ Allow gateway transit: Leave as "None" unless you have a VPN Gateway in one of the VNets and want the other VNet to use it for connectivity to on-premises networks.
		Click Add.
		You should now see two peering links: vnet1-to-vnet2 and vnet2-to-vnet1, both with a Peering status of Connected.
<img width="1307" height="290" alt="image" src="https://github.com/user-attachments/assets/93c0663d-235f-484e-a7c8-cdd3df254d8e" />

<img width="1308" height="303" alt="image" src="https://github.com/user-attachments/assets/817e71ae-bdfa-452d-af41-2bc0ba8cd4d4" />
**Step 6: Verify Communication**

	To ensure the VMs can communicate, you'll need to:
	1. Get the Private IP Addresses of the VMs:
		○ Go to peervm1 in the Azure Portal. In the "Overview" section, note down its Private IP address .
		○ Go to peervm2  in the Azure Portal. In the "Overview" section, note down its Private IP address.
	2. Connect to peervm1  (via RDP/SSH):
		○ On the peervm1  overview page, click Connect.
		○ Select RDP (for Windows) or SSH (for Linux).
		○ Download the RDP file or get the SSH command.
		○ Connect to peervm1  using the public IP and credentials you set up.
	3. From peervm1 , Ping peervm2's Private IP:
		○ For Windows VMs:
			§ Open Command Prompt or PowerShell.
			§ Type ping <peervm2_Private_IP_Address> (e.g., ping 10.1.0.4).
			§ You should see successful replies.
		○ For Linux VMs:
			§ Open Terminal.
			§ Type ping <peervm2_Private_IP_Address> (e.g., ping 10.1.0.4).
			§ You should see successful replies.
	4. Connect to peervm2  (via RDP/SSH):
		○ Connect to peervm2  using its public IP and credentials.
	5. From peervm2 , Ping peervm1's Private IP:
		○ Perform the same ping test as above, but from peervm2 to peervm1's private IP.
		You should also see successful replies.
**peerVM1's IP Private address**
<img width="649" height="246" alt="image" src="https://github.com/user-attachments/assets/d5066ee5-eabd-4f9c-88f2-b987df2349e8" />

**peerVM2's IP Private address**
<img width="682" height="247" alt="image" src="https://github.com/user-attachments/assets/b220740d-eba2-40e0-a7a7-6542aacef0d6" />

**SUCESSFUL PING RESPONSE FROM peevm2 TO peervm1**
<img width="543" height="163" alt="image" src="https://github.com/user-attachments/assets/84db71e1-64bb-4293-84ec-56028c6bf95c" />

**SUCESSFUL PING RESPONSE FROM peevm1 TO peervm2**
<img width="533" height="161" alt="image" src="https://github.com/user-attachments/assets/0d35b409-9083-4c74-86cc-fee96d3c539d" />













