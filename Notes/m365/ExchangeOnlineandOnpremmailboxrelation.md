In a Hybrid Exchange environment, what happens depends on how you create the mailbox on-premises.
Scenario 1: You create an on-premises mailbox (New-Mailbox)
This creates a mailbox hosted on the on-prem Exchange database.
Flow:

Active Directory User
 │
 ▼
On-Prem Exchange Mailbox
 │
 ▼
Entra Connect Sync
 │
 ▼
Exchange Online receives only a Mail User / Synced Object
 │
 ▼
No cloud mailbox is created
Result in Exchange Online:
	• A synchronized recipient object appears in EXO/GAL.
	• The object is shown as MailUser (or synced mailbox object), not a cloud mailbox.
	• Users can see it in the Global Address List.
	• Mailbox data remains entirely on-prem.
	• Outlook/EWS/OWA connections go to on-prem Exchange.
	• To host the mailbox in EXO later, you would perform a mailbox move (remote move migration). [learn.microsoft.com], [learn.microsoft.com]

Scenario 2: You create a Remote Mailbox on-prem (Enable-RemoteMailbox or New-RemoteMailbox)
This is the recommended method when the mailbox should live in Exchange Online.
Flow:

AD User Created
 │
 ▼
Enable-RemoteMailbox
 │
 ▼
Exchange stamps remote mailbox attributes
(remoteRoutingAddress, RecipientTypeDetails, etc.)
 │
 ▼
Entra Connect Sync
 │
 ▼
Object synchronized to Microsoft Entra ID
 │
 ▼
Exchange Online provisions actual mailbox
 │
 ▼
User mailbox appears in EXO
Microsoft states that Enable-RemoteMailbox creates a mail-enabled user with attributes indicating a mailbox should be created in the cloud once directory synchronization occurs. Mailbox creation is dependent on the sync cycle and is not immediate. [learn.microsoft.com], [learn.microsoft.com]
Result in Exchange Online:
	• A real UserMailbox is created in EXO.
	• Email is stored in Exchange Online.
	• Object remains authoritative on-prem for identity attributes.
	• The mailbox appears in Exchange Online Admin Center.
	• Depending on your hybrid configuration, you continue managing many recipient properties from on-prem Exchange. [learn.microsoft.com], [learn.microsoft.com]

End-to-End Example
Let's say you create:

New-ADUser testuser
Enable-RemoteMailbox testuser </span><br></div><div><span attribution="{&quot;id&quot;:&quot;E64C3D4F-5E12-4514-AD9B-893A6FAFD00C&quot;,&quot;name&quot;:&quot;Copilot&quot;,&quot;oid&quot;:&quot;E64C3D4F-5E12-4514-AD9B-893A6FAFD00C&quot;,&quot;timestamp&quot;:1790141400000,&quot;dataSource&quot;:0}"> -PrimarySmtpAddress testuser@contoso.com 
-RemoteRoutingAddress testuser@contoso.mail.onmicrosoft.com
What happens?
	1. AD user is created.
	2. Exchange stamps remote mailbox attributes: 
		○ targetAddress
		○ remoteRoutingAddress
		○ Exchange recipient attributes
	3. Entra Connect syncs the object.
	4. Microsoft Entra ID receives the synchronized user.
	5. Exchange Online detects the remote mailbox attributes.
	6. Exchange Online provisions the mailbox.
	7. License assignment enables full mailbox functionality.
	8. Mailbox appears as:

Get-Mailbox testuser
in Exchange Online. [learn.microsoft.com], [learn.microsoft.com]

What appears where?
Object Location	On-Prem Mailbox	Remote Mailbox / EXO Mailbox
Active Directory	User object	User object
On-Prem Exchange	Real mailbox	Remote mailbox object only
Exchange Online	Synced mail user/object	Actual mailbox
Mail storage	On-prem DB	Exchange Online
Mailbox moves needed	Yes, to move to cloud	No, already cloud-hosted

Common Hybrid Operational Model
Most organizations that have completed mailbox migrations use:

Create User in AD
 ↓
Enable-RemoteMailbox
 ↓
AAD Connect Sync
 ↓
Assign EXO License
 ↓
Mailbox Created in Exchange Online
This keeps Exchange as the recipient-management authority on-prem while hosting the mailbox in Exchange Online. Microsoft documents this as the standard remote mailbox provisioning model in hybrid deployments. [learn.microsoft.com], [learn.microsoft.com]
Quick verification commands
On-prem Exchange

Get-RemoteMailbox user@contoso.com

If it returns data, the object is intended for EXO.
Exchange Online

Get-Mailbox user@contoso.com
If it returns a mailbox, provisioning completed successfully.

Microsoft references
	• Exchange Hybrid Deployments: https://learn.microsoft.com/exchange/exchange-hybrid [learn.microsoft.com]
	• Enable-RemoteMailbox cmdlet: https://learn.microsoft.com/powershell/module/exchangepowershell/enable-remotemailbox [learn.microsoft.com]
	• Move mailboxes in Hybrid: https://learn.microsoft.com/exchange/hybrid-deployment/move-mailboxes [learn.microsoft.com]
A useful follow-up concept is understanding what attributes (targetAddress, msExchRemoteRecipientType, ExchangeGUID, etc.) trigger EXO mailbox creation during the sync cycle, which is often the key to troubleshooting hybrid provisioning issues.
Great question. In a Hybrid Exchange environment, the Exchange Online license is what actually activates and sustains the cloud mailbox. Without the license, synchronization alone does not give the user a fully functional Exchange Online mailbox. [learn.microsoft.com], [learn.microsoft.com]
Think of it this way
Exchange Hybrid has 3 separate components:
Component	Purpose
On-prem AD	User identity
Entra Connect	Synchronizes identity and Exchange attributes
Exchange Online License	Enables mailbox services in Microsoft 365
A synced user can exist in Microsoft 365 without a license, but they won't receive the full Exchange Online mailbox capabilities tied to the license. Mailbox plans and mailbox settings in Exchange Online are associated with the assigned Exchange Online license. [learn.microsoft.com]

Typical Mailbox Creation Flow in Hybrid
Step 1: Create Remote Mailbox On-Prem

Enable-RemoteMailbox user1
``
This stamps Exchange attributes in Active Directory indicating that a cloud mailbox should exist. [learn.microsoft.com]
Step 2: Entra Connect Sync
The user object syncs to Microsoft 365.
At this point:

User exists in Entra ID
Mailbox may be provisioned in EXO
Not fully usable yet if no license
Step 3: Assign Exchange Online License
Examples:
	• Exchange Online Plan 1
	• Exchange Online Plan 2
	• Microsoft 365 E3
	• Microsoft 365 E5
	• Microsoft 365 Business Premium
Mailbox plans in Exchange Online are directly tied to license types. [learn.microsoft.com]
Step 4: Mailbox Becomes Fully Functional
User can:
	• Send/receive mail
	• Access Outlook on the web
	• Use Outlook desktop/mobile
	• Use archives (if licensed)
	• Use retention/compliance features permitted by the license

What Happens If No License Is Assigned?
A common misconception is:
	"I created a remote mailbox on-prem, so the mailbox should work."
Not necessarily.
Without an Exchange Online-capable license:
	• User object syncs.
	• Exchange attributes sync.
	• Exchange Online cannot provide the entitled mailbox service long-term.
	• User won't have full mailbox functionality associated with Exchange Online licensing. [learn.microsoft.com]

During Mailbox Migration
When you migrate an on-prem mailbox to Exchange Online:

On-Prem Mailbox
 ↓
Hybrid Move Request
 ↓
Mailbox Data Copied to EXO
 ↓
Cutover Complete
 ↓
User Uses EXO Mailbox
After migration completes, the Exchange Online mailbox requires appropriate licensing to remain supported and functional. Hybrid deployments support moving mailboxes between on-premises Exchange and Exchange Online while maintaining coexistence. [learn.microsoft.com], [learn.microsoft.com]

What Does the License Actually Control?
Exchange Online Plan 1
Provides:
	• 50 GB mailbox
	• Outlook access
	• ActiveSync
	• Basic retention features
Exchange Online Plan 2 / M365 E3/E5
Adds:
	• Larger mailbox quotas
	• Archive mailbox
	• Advanced compliance capabilities
	• Advanced retention/litigation features (depending on SKU)
Mailbox configuration defaults are applied through mailbox plans associated with the assigned license. [learn.microsoft.com]

An Important Hybrid Administration Point
In traditional hybrid deployments:

Mailbox = Exchange Online
Identity = On-Prem AD
Recipient Management = Often On-Prem Exchange

Even though the mailbox is hosted in Exchange Online, many Exchange attributes are still authored on-prem and synchronized to the cloud. Microsoft specifically describes this source-of-authority model for synchronized hybrid users. [learn.microsoft.com], [learn.microsoft.com]

Real-World Example
Suppose your organization creates a new employee.
On-Prem

New-ADUser Sourav
Enable-RemoteMailbox Sourav
Sync
Azure/Entra Connect syncs the user.
Without License
Microsoft 365 shows:

User Exists ✅
Mailbox Provisioning Attributes ✅
Usable EXO Mailbox ❌
After Assigning Microsoft 365 E3

User Exists ✅
Mailbox Created ✅
OWA Access ✅
Outlook Access ✅
50GB+/Archive Features Based on License ✅

Quick Rule of Thumb
Scenario	Exchange Online License Needed?
On-prem mailbox only	No
Remote mailbox hosted in EXO	Yes
Migrated mailbox now in EXO	Yes
Shared mailbox (<50GB and no direct login)	Often not required unless advanced features or size requirements apply
Mail Contact / Mail User only	No
The key takeaway: In Hybrid Exchange, synchronization creates the object, but the Exchange Online license unlocks and governs the cloud mailbox service. Sync and licensing are separate processes, and both are required for a normal Exchange Online user mailbox. [learn.microsoft.com], [learn.microsoft.com]
Microsoft references
	• Enable-RemoteMailbox (Exchange PowerShell): https://learn.microsoft.com/powershell/module/exchangepowershell/enable-remotemailbox [learn.microsoft.com]
	• Exchange Server hybrid deployments: https://learn.microsoft.com/exchange/exchange-hybrid [learn.microsoft.com]
	• Mailbox plans in Exchange Online: https://learn.microsoft.com/exchange/recipients-in-exchange-online/manage-user-mailboxes/mailbox-plans [learn.microsoft.com]
	• Cloud-based management of Exchange attributes for Remote Mailboxes: https://learn.microsoft.com/exchange/hybrid-deployment/enable-exchange-attributes-cloud-management [learn.microsoft.com]

From <https://m365.cloud.microsoft/hwav2/chat/agent/T_0e902970-556c-d6f6-daeb-33da0ccfc69f.892d63f8-790c-4818-8896-28a144b2f954.gpt.6b8da7da-b007-4bfe-afe1-1fc9d42f5556/conversation/fd7d9b77-c98e-4266-9cf9-61695f1ccb57?version=19.2609.44031.0&capabilities=interopPromise%2CsuspendOnClose%2CautoStart&client-request-id=71884ccf-29d8-cd4b-b7fe-15fd9629ca1b&appstate=suspended&SSRDesktopTest=2> 

No, it will not appear in Exchange Online automatically as a usable cloud mailbox, and doing this can actually cause major mail flow issues. [1] 
Because you are in a hybrid environment, the target location for a user's mailbox matters heavily. Creating an on-premises mailbox keeps that user's data entirely on your physical local server. While Microsoft Entra Connect (formerly Azure AD Connect) will synchronize the Active Directory account to the cloud, it will only sync it as a mail-enabled user or a regular user account, not as an Exchange Online cloud mailbox. [2, 3] 
If you then mistakenly assign an Exchange Online license to that user in the cloud, Microsoft 365 will try to provision a second mailbox in the cloud. This creates a "dual mailbox" state, which breaks internal mail flow (on-premises users will email the on-premises mailbox, and cloud users will email the cloud mailbox). [1, 4] 
Here are the correct ways to provision mailboxes in an Exchange Hybrid environment:
Scenario A: You want the mailbox to live in Exchange Online (Cloud)
If you already created the AD user account and want their mailbox to live in the cloud, you must provision it as a Remote Mailbox from your on-premises environment. [5, 6] 
	1. Run the Remote Mailbox command via the on-premises Exchange Management Shell:
Enable-RemoteMailbox -Identity "Username" -RemoteRoutingAddress "username@://onmicrosoft.com"

Note: The -RemoteRoutingAddress must use your hybrid routing domain (usually ending in .mail.onmicrosoft.com) so the on-premises server knows to route mail for this user to the cloud. [6, 7] 
	2. Wait for your directory synchronization cycle to run (or force a delta sync using Start-ADSyncSyncCycle -PolicyType Delta in PowerShell). [7] 
	3. Assign a license: Once the user synchronizes to the Microsoft 365 Admin Center, assign an Exchange Online license. The cloud mailbox will then provision automatically. [3, 5, 8] 
(Alternatively, if you haven't created the AD account yet, you can go to your On-Premises EAC > Recipients > Mailboxes > click the + icon > and choose Office 365 Mailbox. This creates the AD user and the remote mailbox simultaneously.) [9, 10] 
Scenario B: You already created it On-Premises and want to move it to the Cloud
If you followed the steps from the previous response and already provisioned a full local mailbox on your local server, you must explicitly migrate it: [2, 11] 
	1. Wait for the AD account to sync to the cloud via Microsoft Entra Connect.
	2. Go to the Exchange Online Admin Center (https://admin.exchange.microsoft.com).
	3. Navigate to Recipients > Migration.
	4. Click Add migration batch and select Migrate to Exchange Online (Remote Move migration).
	5. Select the user, choose your on-premises endpoint, and run the migration batch to move the mailbox data to the cloud. [3, 8, 11, 12] 
Which option aligns best with what you need to achieve right now?
	1. I want to fix the mailbox I already created on-premises and move it to the cloud.
	2. I want to delete my mistake and properly provision a new cloud mailbox from scratch.
	3. I actually intended for the user to stay on-premises completely.
Reply with the number or let me know if you need the PowerShell scripts to fix a dual-mailbox state!
[1] https://learn.microsoft.com
[2] https://learn.microsoft.com
[3] https://www.youtube.com
[4] https://www.youtube.com
[5] https://www.reddit.com
[6] https://learn.microsoft.com
[7] https://techcommunity.microsoft.com
[8] https://www.o365cloudexperts.com
[9] https://www.alitajran.com
[10] https://agileit.com
[11] https://www.youtube.com
[12] https://www.youtube.com

From <https://www.google.com/search?q=i+have+create+a+AD+user+account+and+want+to+provision+a+mailbox%2C+how%27d+i+do+it%3F&rlz=1C1GCEA_enIN1126IN1126&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCTE4MTU5ajBqNKgCALACAQ&sourceid=chrome&ie=UTF-8&fbs=ABfTbFVyMZGZf1hfvX9uKjN_-G8cxpBkeIeqYwoCbfNVc4vKE5XdvSlI_LORjvMqi_KlDwkgv0zYxJdoCL2NzkSVgWxp0K18g6UI5ilf6phniJrsO5VqfBLthzoqmpIoJ1Ko8XqMnCje59fyEbhJGQ3xlLqcSJAFLqehVyM3OWrCVKZJreDUQlPvUxo7Sjchwlw6v_YRa1gqcv45-51fczaD7JxwxDhs7g&aep=10&ntc=1&sxsrf=APpeQnvEMr30ClBl0fqHOzojj08GbV-viQ%3A1790143102501&mstk=AUtExfAkhKaOS7ra9EFGcyDHxN-wUQlih3AGEM-ooMUpXp0kwJ6iZPxHjHXtE_mwwK6VsWqc8ceqlE6BFjqms0iAORtsYz6-BNZwE5qEqWyr-26EelqK7VYJ4ZL90IZREd8jFya_3XxdJgVhu8RIVi2HTR9GovGhJ5XGg1hrpiT1Kfqzo3htGhDVyn933eLNGWBIZrC6zpLy8hekHr5o9DFRCI1YRkqeSpP4kuNsbpaPqg-NSPd-88atML__JA&aioh=3&csuir=1&cs=1&udm=50&mtid=FGuzasH6ApTU4-EP1Ye0kQU> 

You can provision a mailbox for an existing Active Directory user by using the Exchange Admin Center (EAC) or the Exchange Management Shell. [1] 

Method 1: Using the Exchange Admin Center (EAC)
	1. Open your browser and go to your Exchange Admin Center URL (e.g., https://<your-exchange-server>/ecp or via the Microsoft 365 Admin Center if you are in a hybrid/cloud setup).
	2. Log in with your administrator account.
	3. Go to Recipients and select Mailboxes.
	4. Click the + (New) icon and select User mailbox.
	5. Choose Existing user instead of a new user.
	6. Click Browse, locate and select the Active Directory user account you already created, and click OK.
	7. Fill in any optional fields like the alias, then click Save. [2, 3, 4, 5] 

Method 2: Using Exchange Management Shell (PowerShell)
If you prefer using the command line, run the following command: [1, 2] 
Enable-Mailbox -Identity "Username" -Database "Mailbox Database Name"
(Replace "Username" with your AD account's SAMAccountName or user principal name, and "Mailbox Database Name" with your target database storage). [6, 7] 
To accurately verify where a mailbox lives and find conflicts (like dual-mailbox states), you must check the user's properties from both sides of your hybrid setup: the On-Premises Exchange Management Shell (EMS) and the Exchange Online (EXO) PowerShell. [1, 2] 
Below are the commands to run and how to interpret the results to diagnose mail flow. [3, 4] 

Step 1: Check On-Premises (via Exchange Management Shell)
Run the following command on-premises to see how your local Exchange server views the account: [1] 
Get-Recipient -Identity "username" | Select-Object Name, RecipientType, RecipientTypeDetails
🔍 How to interpret On-Premises results:
	• UserMailbox: The physical mailbox database sits on-premises. The local server will always route mail to its internal database.
	• MailUser (with a RecipientTypeDetails of RemoteUserMailbox): This is correct for a cloud mailbox! It means the on-premises server knows the mailbox is in the cloud and will route emails out via your hybrid send connectors. [5, 6] 
	• User: The account exists in AD but has no mailbox configuration at all on-premises. (This will break mail flow from on-prem users to this user). [7] 

Step 2: Check Cloud (via Exchange Online PowerShell)
Connect to Exchange Online (Connect-ExchangeOnline) and run: [2] 
Get-Recipient -Identity "username" | Select-Object Name, RecipientType, RecipientTypeDetails
🔍 How to interpret Exchange Online results:
	• UserMailbox: The mailbox is actively provisioned in Exchange Online (Cloud).
	• MailUser: The cloud recognizes the user but thinks the mailbox is on-premises or somewhere external. [8] 

🚨 Troubleshooting the Relationship (The Golden Matrix)
Compare your results from both environments to understand your current status or find a routing conflict:
On-Premises Result	Exchange Online Result	Status & Mail Flow Impact
RemoteUserMailbox	UserMailbox	Perfect Hybrid State. On-prem correctly routes mail to the cloud, and the cloud holds the mailbox.
UserMailbox	MailUser	Perfect On-Prem State. The mailbox lives locally, and the cloud correctly knows to route mail down to your local server.
UserMailbox	UserMailbox	❌ CRITICAL: Dual-Mailbox State. Both systems think they own the mailbox. On-prem users can't email cloud users and vice-versa, resulting in missing or siloed emails.
User	UserMailbox	⚠️ Broken On-Prem Routing. The cloud has a mailbox, but your on-premises Exchange doesn't know it exists. On-premises users will get NDRs (bounce backs) trying to email this user.
🛠️ Pro-Tip: Cross-Checking the ExchangeGuid
For a hybrid environment to route and migrate properly, the unique mailbox ID must match on both sides. If you suspect a deeper sync issue, compare these two outputs: [1] 
	• On-Premises EMS: Get-RemoteMailbox "username" | Select-Object ExchangeGuid
	• Exchange Online: Get-Mailbox "username" | Select-Object ExchangeGuid [1] 
If the mailbox is in the cloud, these strings must match exactly. If the On-Premises GUID is all zeroes (00000000...), it will cause directory sync errors and break hybrid functionality. [1, 6] 
Did you find a user that matches one of the problematic states (like the Dual-Mailbox or Broken On-Prem Routing)? I can give you the exact PowerShell commands to:
	1. Fix a Dual-Mailbox state without losing cloud or on-prem email data.
	2. Convert a local mailbox to a RemoteMailbox so on-premises routing starts working.
Let me know what your commands returned or which fix you need!
[1] https://learn.microsoft.com
[2] https://nishantrana.me
[3] https://www.youtube.com
[4] https://www.linkedin.com
[5] https://learn.microsoft.com
[6] https://www.samuraj-cz.com
[7] https://docs.oneidentity.com
[8] https://technet440.rssing.com

From <https://www.google.com/search?q=i+have+create+a+AD+user+account+and+want+to+provision+a+mailbox%2C+how%27d+i+do+it%3F&rlz=1C1GCEA_enIN1126IN1126&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCTE4MTU5ajBqNKgCALACAQ&sourceid=chrome&ie=UTF-8&fbs=ABfTbFVyMZGZf1hfvX9uKjN_-G8cxpBkeIeqYwoCbfNVc4vKE5XdvSlI_LORjvMqi_KlDwkgv0zYxJdoCL2NzkSVgWxp0K18g6UI5ilf6phniJrsO5VqfBLthzoqmpIoJ1Ko8XqMnCje59fyEbhJGQ3xlLqcSJAFLqehVyM3OWrCVKZJreDUQlPvUxo7Sjchwlw6v_YRa1gqcv45-51fczaD7JxwxDhs7g&aep=10&ntc=1&sxsrf=APpeQnvEMr30ClBl0fqHOzojj08GbV-viQ%3A1790143102501&mstk=AUtExfAkhKaOS7ra9EFGcyDHxN-wUQlih3AGEM-ooMUpXp0kwJ6iZPxHjHXtE_mwwK6VsWqc8ceqlE6BFjqms0iAORtsYz6-BNZwE5qEqWyr-26EelqK7VYJ4ZL90IZREd8jFya_3XxdJgVhu8RIVi2HTR9GovGhJ5XGg1hrpiT1Kfqzo3htGhDVyn933eLNGWBIZrC6zpLy8hekHr5o9DFRCI1YRkqeSpP4kuNsbpaPqg-NSPd-88atML__JA&aioh=3&csuir=1&cs=1&udm=50&mtid=FGuzasH6ApTU4-EP1Ye0kQU> 

