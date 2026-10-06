# SQL-Database-set-up

Building an SQL Database on Azure
This guide will walk you through the process of setting up an SQL database on Azure, configuring server-level firewall rules, connecting to your database, and creating tables within it.

**Step 1: Create an SQL Database on Azure**

Sign in to Azure Portal: Go to portal.azure.com and sign in with your Azure account.

Create a new resource: In the Azure portal, click on the "Create a resource" button (usually a green plus sign) in the left-hand navigation pane.

Search for SQL Database: In the "Search services and marketplace" box, type "SQL Database" and select it from the results.

Configure SQL Database:

Click "Create".

Basics Tab:

Subscription: Choose your Azure subscription.

Resource group: Create a new one or select an existing one. A resource group is a logical container for your Azure resources.

Database name: Enter a unique name for your database (e.g., myFirstAzureSQLDB).

Server: Click "Create new" to set up a new SQL server.

Server name: Enter a unique server name (e.g., myazuresqlserver12345).

Server admin login: Choose a username for your server administrator (e.g., sqladmin).

Password: Set a strong password and confirm it. Remember this password!

Location: Choose a region close to you or your users for better performance.

Click "OK".

Want to use SQL elastic pool? Select "No".

Compute + storage: Click "Configure database" to choose your pricing tier. For a basic setup, you can start with a "Basic" or "Standard" tier with a lower DTU/vCore count. You can always scale up later.

Click "Review + create".

Networking Tab:

Connectivity method: Select "Public endpoint".

Firewall rules:

Allow Azure services and resources to access this server: Select "Yes". This allows other Azure services (like Azure App Service) to connect to your database.

Add current client IP address: Select "Yes". This is crucial for you to be able to connect from your current machine.

Review + create: Review your settings and click "Create".

Deployment: Azure will now deploy your SQL server and database. This may take a few minutes. Once completed, you will see a "Deployment succeeded" message.

<img width="1842" height="784" alt="image" src="https://github.com/user-attachments/assets/af363f9a-ecfb-4f27-b797-31e598ffa019" />

<img width="1827" height="407" alt="image" src="https://github.com/user-attachments/assets/b98a61db-36c8-4112-adbf-e57ad1a71820" />


**Step 2: Create an IP Firewall Rule at the Server Level**

Even if you added your current IP during creation, it's good to know how to manage firewall rules.

Navigate to your SQL Server: In the Azure portal, search for and select your newly created SQL server (e.g., myazuresqlserver12345).

Go to Networking: In the left-hand menu of your SQL server blade, under "Security," click on "Networking."

Add a new firewall rule:

Under "Firewall rules," you will see existing rules (including the one for your client IP if you added it).

To add a new rule, click "+ Add a firewall rule".

Rule name: Give it a descriptive name (e.g., OfficeIP).

Start IP: Enter the starting IP address of the range you want to allow.

End IP: Enter the ending IP address of the range you want to allow. If it's a single IP, enter the same IP for both start and end.

Click "Save" at the top.

<img width="1556" height="796" alt="image" src="https://github.com/user-attachments/assets/f9285cb0-464b-44fe-8641-0e1f6c44097e" />


**Step 3: Link to the Database**

You can link to your database using various tools. SQL Server Management Studio (SSMS) is a popular choice for Windows users, while Azure Data Studio is cross-platform.

Option A: Using SQL Server Management Studio (SSMS)
Download SSMS: If you don't have it, download and install SQL Server Management Studio from the official Microsoft website.

Get Server Name: In the Azure portal, navigate to your SQL database (not the server). On the "Overview" blade, you will find the "Server name" (e.g., myazuresqlserver12345.database.windows.net). Copy this.

Connect in SSMS:

Open SSMS.

In the "Connect to Server" dialog box, for "Server type," select "Database Engine."

For "Server name," paste the server name you copied from Azure.

For "Authentication," select "SQL Server Authentication."

For "Login," enter your server admin login (e.g., sqladmin).

For "Password," enter the password you set during server creation.

Click "Connect."

Expand Databases: Once connected, in the "Object Explorer" pane, expand "Databases" to see your newly created database.

Option B: Using Azure Data Studio
Download Azure Data Studio: If you don't have it, download and install Azure Data Studio from the official Microsoft website.

Get Server Name: In the Azure portal, navigate to your SQL database. On the "Overview" blade, you will find the "Server name" (e.g., myazuresqlserver12345.database.windows.net). Copy this.

Connect in Azure Data Studio:

Open Azure Data Studio.

Click on the "New Connection" icon (usually a plug icon).

Connection type: Select "Microsoft SQL Server."

Server: Paste the server name you copied from Azure.

Authentication type: Select "SQL Login."

User name: Enter your server admin login (e.g., sqladmin).

Password: Enter the password you set during server creation.

Database: (Optional) You can specify your database name here.

Click "Connect."

**Option C:THE METHOD I USED TO ACCESS THE DATABASE WITHOUT HAVING TO USE ANY APP I USED IS MENTIONED BELOW**

Using Azure Portal Query Editor
Go to your Azure SQL Database in the Azure Portal.
Click on Query Editor (Preview).
Sign in with your credentials.
Run SQL queries directly from the browser.

<img width="1899" height="691" alt="image" src="https://github.com/user-attachments/assets/bd649e00-1531-478a-b7b3-d41b7037a178" />

**Step 4: Create Tables in the Database**

Once connected to your database using SSMS or Azure Data Studio, you can create tables using SQL CREATE TABLE statements.

Example: Creating a Customers Table
Open a New Query: In SSMS or Azure Data Studio, right-click on your database name in the Object Explorer and select "New Query."

Write and Execute SQL: In the query editor, type the following SQL statement to create a Customers table:

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(255)
);

CustomerID INT PRIMARY KEY IDENTITY(1,1): Creates an auto-incrementing primary key.

NVARCHAR(50) NOT NULL: Defines a string column that cannot be empty.

UNIQUE: Ensures all values in the Email column are unique.

Execute the Query: Click the "Execute" button (usually a red exclamation mark or a play button). If successful, you'll see a "Commands completed successfully" message.

Example: Creating an Orders Table
You can also create another table and link it to the Customers table using a foreign key.

Open a New Query: Open another new query window.

Write and Execute SQL:

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    OrderStatus NVARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID): This line creates a relationship, ensuring that every CustomerID in the Orders table must exist in the Customers table.

Execute the Query: Click "Execute."

<img width="631" height="625" alt="image" src="https://github.com/user-attachments/assets/45745ed7-e4ca-437e-9891-5386c74bf0d0" />

Verify Tables
To verify that your tables have been created:

In SSMS or Azure Data Studio, in the Object Explorer, right-click on your database name, then click "Refresh."

Expand your database, then expand "Tables." You should now see dbo.Customers and dbo.Orders listed.

You have successfully set up an SQL database on Azure, configured firewall rules, connected to it, and created tables!
