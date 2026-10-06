# Custom-PS-Script-run-as-VM-Extension-
**1: Prepare Your Script**
Create a PowerShell script (.ps1) that installs or configures the software.
Example: ChromeInstall.ps1
Codes to be used:
Invoke-WebRequest -Uri "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile "chrome_installer.exe"
Start-Process "chrome_installer.exe" -ArgumentList "/silent /install" -Wait
**And save it as powershell script extension based file .ps1.**

**2. Upload your Software Installer and Script to Azure Storage:**

Create an Azure Storage Account: Go to Azure Portal -> Storage Accounts -> Create. Choose a descriptive name and a region close to your VM.

Create a Blob Container: Inside your storage account, go to "Containers" -> "+ Container". Give it a name (e.g., software-deployments) and set "Public access level" to Private.

Upload Files: Upload both your  ChromeInstall.ps1 files to this container.

Generate SAS URL for Installer:

Navigate to your **ChromeInstall** blob.

Select "Generate SAS" from the left menu.

Set appropriate permissions (Read) and an expiry time that gives you enough time for deployment.

Click "Generate SAS token and URL". Copy the "Blob SAS URL".

Replace YOUR_SAS_URL_TO_INSTALLER in your ChromeInstall.ps1 script with this generated SAS URL.

**3. Deploy the Custom Script Extension to your VM**
You have several options to deploy the extension:

Option A: Azure Portal (Simplest for single VM)

Navigate to your VM: In the Azure portal, go to "Virtual machines" and select your Windows 10 VM.

Go to Extensions: In the left-hand menu, under "Settings", select "Extensions + applications".

Add an Extension: Click "+ Add".

Find Custom Script Extension: Search for "Custom Script Extension" and select it, then click "Next".

Configure Extension Settings:

PowerShell File: Here you have two main choices:

Provide the SAS URL of your Chromeinstall.ps1 script (the one you uploaded to Blob Storage).

**Step 4: Verify Installation**
Once the extension shows "Succeeded" in the Azure portal, RDP into your Windows 10 VM and verify that "Chrome" has been installed correctly.
