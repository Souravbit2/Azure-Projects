# Azure-Cosmos-DB

### How to Set Up Azure Cosmos DB
Setting up Azure Cosmos DB generally involves creating an Azure Cosmos DB account, then creating a database and containers within that account. Here's a step-by-step guide using the Azure portal (the most common method):

Prerequisites:

An Azure account with an active subscription. You can create a free Azure account if you don't have one.

Steps:

Sign in to the Azure Portal: Go to https://portal.azure.com/ and sign in with your Azure credentials.

Create an Azure Cosmos DB Account:

In the Azure portal's search bar, type "Azure Cosmos DB" and select it from the services list.

On the Azure Cosmos DB page, click + Create.

On the "Create Azure Cosmos DB Account" page, you'll configure the basic settings:

Azure Cosmos DB for [API]: Choose the API that best suits your application's needs. The most common is NoSQL (Recommended), but you can also choose MongoDB, Gremlin, Cassandra, or Table API. For this guide, let's assume you choose NoSQL.

Subscription: Select your Azure subscription.

Resource Group: Create a new resource group or select an existing one. A resource group is a logical container for your Azure resources.

Account Name: Provide a globally unique name for your Cosmos DB account. This name will be part of the endpoint URL.

Location: Select the Azure region closest to your users for optimal performance.

Capacity mode:

Provisioned throughput: You manually set the Request Units per second (RU/s) for predictable workloads.

Serverless: You pay only for the operations you perform, suitable for sporadic or unpredictable workloads.

Apply Azure Cosmos DB free tier discount: If eligible, you can apply this to get the first 1000 RU/s and 25 GB of storage for free.

Review other optional settings like geo-redundancy and multi-region writes if your application requires them.

Click Review + create, then Create.
Wait for the deployment to complete (this might take a few minutes). Once done, click Go to resource.

<img width="1266" height="626" alt="image" src="https://github.com/user-attachments/assets/99a2dda9-9287-4611-a3b1-6bdb05995d5b" />


### Create a Database and Container:

Once you are on your Azure Cosmos DB account page, in the left-hand menu, under "Data Explorer," select Data Explorer.

In the Data Explorer, click New Container.

In the "New Container" dialog, configure the following:

Database:

Create new: Enter a name for your new database (e.g., MyDatabase).

Use existing: Select an existing database if you have one.

Share throughput across containers:

Selected: Throughput is shared across all containers in the database.

Unselected: Each container has its own dedicated throughput. (Recommended for most cases unless you have a strong reason to share).

Container id: Enter a name for your container (e.g., MyContainer).

Partition key: This is crucial for performance and scalability. Choose a property from your data that will be used to distribute data across partitions (e.g., /productId, /userId). A good partition key distributes data evenly and allows for efficient queries.

Container throughput: Set the throughput (RU/s) for your container. You can choose Autoscale for automatic scaling or Manual to set a fixed amount.

Click OK.



Add Sample Data (Optional):

In the Data Explorer, expand your newly created database and container.

Select Items.

Click New Item in the menu.

A JSON editor will appear. You can paste sample JSON data here. For example:

JSON

{
    "id": "item1",
    "name": "Product A",
    "price": 10.99,
    "category": "Electronics",
    "quantity": 100
}
Click Save.

Query Data (Optional):

In the Data Explorer, select New SQL Query.

You can write SQL-like queries to retrieve data. For example:

SQL

SELECT * FROM c WHERE c.category = "Electronics"
Click Execute Query.

<img width="1281" height="459" alt="image" src="https://github.com/user-attachments/assets/799fd901-fd59-458a-886d-fb5f4003627d" />

### Connecting to Azure Cosmos DB from your Application:

To use Azure Cosmos DB in your application, you'll typically use one of the Azure Cosmos DB SDKs (available for .NET, Java, Node.js, Python, and more).

Get Connection String/Keys:

On your Azure Cosmos DB account page in the Azure portal, navigate to Keys under the "Settings" section in the left menu.

Here you'll find the URI (Endpoint) and Primary Key (or secondary key). You'll use these credentials in your application to connect to your Cosmos DB account.

Install the SDK: Install the appropriate Azure Cosmos DB SDK for your chosen programming language using a package manager (e.g., npm install @azure/cosmos for Node.js, pip install azure-cosmos for Python).

Write Code: Use the SDK to interact with your Cosmos DB account, databases, and containers. The code will involve:

Creating a CosmosClient object using your endpoint and key.

Getting references to your database and container.

Performing CRUD (Create, Read, Update, Delete) operations on items.

This provides a foundational understanding of Azure Cosmos DB and how to get started with it. The specifics of data modeling, partitioning strategy, and application development will depend on your specific use case.





Tools

Gemini can make mistakes, so double-check it
