Detailed Guide: Creating an Azure Web App for a Simple Portfolio
This guide will walk you through the process of setting up a simple portfolio website using Azure Web Apps. We'll focus on a straightforward approach, perfect for getting your portfolio online quickly.

1. Prerequisites
Before you begin, make sure you have the following:

Azure Account: If you don't have one, you can sign up for a free Azure account. This often includes free credits or services for a limited period.

A Web Browser: To access the Azure Portal.

Basic Understanding of HTML/CSS: While we'll provide a simple example, knowing the basics will help you customize your portfolio.

Optional: Git (for advanced deployment): If you plan to deploy from a Git repository (like GitHub), ensure Git is installed on your local machine.

2. Navigating the Azure Portal
The Azure Portal is your central hub for managing all your Azure resources.

Open your web browser and go to portal.azure.com.

Sign in with your Azure account credentials.

You'll see the Azure dashboard. From here, you can search for services, view your resources, and manage your subscriptions.

3. Creating Your Azure Web App
Now, let's create the Azure Web App resource.

Click "Create a resource": On the Azure Portal home page, click the green + Create a resource button in the left navigation pane or search bar.

Search for "Web App": In the "Search services and marketplace" box, type Web App and select Web App from the results.

Click "Create": On the Web App overview page, click the Create button.

You'll now be presented with the "Create Web App" form. Fill in the following details:

Project Details

Subscription: Select your Azure subscription (e.g., "Azure subscription 1").

Resource Group: A resource group is a logical container for your Azure resources.

Click Create new and enter a name for your resource group (e.g., my-portfolio-rg). Click OK.

Tip: Using a dedicated resource group helps you manage and delete all related resources easily later.

Instance Details

Name: This will be the unique name for your web app and part of its URL (e.g., my-awesome-portfolio-2025). The full URL will be my-awesome-portfolio-2025.azurewebsites.net. Choose a globally unique name.

Publish: Select Code.

Runtime stack: Choose the technology your web app will run on. For a simple HTML portfolio, HTML is not a direct option. Instead, you can pick a generic one that supports static files:

Node (e.g., Node 18 LTS) is a good general choice, as it can serve static HTML files without needing a complex Node.js application.

Alternatively, PHP or .NET can also serve static files. For simplicity, Node is often recommended for static sites if you're not using a dedicated static site hosting service.

Operating System: Select Linux (generally more cost-effective and flexible for Node/static content).

Region: Choose a region geographically close to your target audience for better performance (e.g., East US, West Europe, Southeast Asia).

App Service Plan

Linux Plan: An App Service Plan defines the underlying computing resources for your web app.

Click Create new.

Linux Plan Name: Give your plan a name (e.g., my-portfolio-plan).

SKU and size: This determines the pricing tier and capabilities.

Click Change size.

For a simple portfolio, the Dev/Test tab offers free and low-cost options.

Select F1 (Free) if available, or B1 (Basic) for a very low-cost option. The F1 tier is excellent for testing and small personal projects.

Click Apply.

Review + create: Click the Review + create button at the bottom.

Create: After validation passes, click the Create button.

Azure will now deploy your Web App. This process usually takes a few minutes. Once complete, you'll see a "Deployment succeeded" message.

4. Accessing Your Web App
Go to resource: Click the Go to resource button on the deployment success page.

Overview: You'll land on your Web App's "Overview" page. Here you can see important information, including the URL of your web app.

Browse: Click the URL link (e.g., https://my-awesome-portfolio-2025.azurewebsites.net). You'll see a default "Welcome to Azure App Service" page. This means your app is running!

5. Preparing Your Simple Portfolio HTML
Let's create a very basic index.html file for your portfolio.

Create a new file named index.html on your local machine and add the following content:

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Simple Portfolio</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
            color: #333;
            text-align: center;
        }
        .container {
            max-width: 800px;
            margin: 30px auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #007bff;
        }
        p {
            margin-bottom: 10px;
        }
        .contact-info a {
            color: #007bff;
            text-decoration: none;
        }
        .contact-info a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello, I'm [Your Name]!</h1>
        <p>I'm a passionate [Your Profession/Hobby] with a keen interest in [Your Area of Interest].</p>
        <p>This is a very simple portfolio page to showcase my presence online.</p>
        <p>Stay tuned for more updates and projects!</p>
        <div class="contact-info">
            <p>You can reach me at: <a href="mailto:your.email@example.com">your.email@example.com</a></p>
            <p>Find me on GitHub: <a href="https://github.com/yourusername" target="_blank">github.com/yourusername</a></p>
        </div>
    </div>
</body>
</html>


Remember to replace [Your Name], [Your Profession/Hobby], [Your Area of Interest], your.email@example.com, and https://github.com/yourusername with your actual details!

6. Deploying Your Portfolio to Azure Web App
For a simple HTML file, the easiest way to deploy is often using the Azure App Service deployment center or FTP. We'll use the Deployment Center for a quick setup.

Navigate to Deployment Center: In your Web App's left navigation pane, under "Deployment", click Deployment Center.

Select Source:

For a very simple, one-time upload, you can use Local Git (even if you're not using a full Git repo, this option allows direct file upload via Kudu).

A more robust solution for ongoing development is GitHub or Azure Repos. For this simple guide, let's assume you'll use a direct method or a simple Git push.

Option A: Using Kudu (Advanced Tools) for Direct File Upload (Simplest for one file)

In your Web App's left navigation pane, under "Development Tools", click Advanced Tools (Kudu).

Click Go. A new tab will open.

In the Kudu interface, click Debug console -> CMD.

Navigate to site -> wwwroot.

You'll see a default hostingstart.html file. You can drag and drop your index.html file directly into this folder. If prompted to overwrite, confirm.

Note: If you have other files (CSS, JS, images), you would upload them here as well, maintaining your folder structure.

Option B: Using Azure CLI / Azure PowerShell (More programmatic)

If you have Azure CLI installed locally, you can use az webapp deploy command.

First, zip your index.html (and any other files/folders) into a .zip file.

Open your terminal/command prompt and run:

az webapp deploy --resource-group my-portfolio-rg --name my-awesome-portfolio-2025 --src-path path/to/your/portfolio.zip --type zip


Replace my-portfolio-rg, my-awesome-portfolio-2025, and path/to/your/portfolio.zip with your actual details.

Option C: Using GitHub Actions (Recommended for version control and automation)

If your portfolio code is on GitHub:

In Deployment Center, select GitHub as the source.

Authorize Azure to access your GitHub account.

Select your Organization, Repository, and Branch (e.g., main).

Azure will automatically set up a GitHub Actions workflow in your repository. Every time you push changes to the selected branch, GitHub Actions will build and deploy your site to Azure.

After deploying your index.html (or your entire portfolio project), go back to your Web App's Overview page and click the URL again. You should now see your simple portfolio page!

7. Next Steps & Customization
Custom Domain: If you own a domain name (e.g., yourportfolio.com), you can map it to your Azure Web App under "Custom domains" in the left navigation.

SSL/TLS Settings: Azure Web Apps automatically provide a free SSL certificate for *.azurewebsites.net domains. If you add a custom domain, you'll need to configure SSL for it.

More Complex Sites: For more complex portfolios (e.g., with a backend, database, or a framework like React/Vue), the deployment process might involve building your application first, but the core Azure Web App setup remains similar.

Monitoring: Explore the "Monitoring" section in the left navigation (e.g., App Service logs, Metrics) to see how your app is performing.

This guide provides a solid foundation for hosting your simple portfolio on Azure. Good luck!
