# Azure-Function-App-Set-Up
The tasks you've outlined describe a common workflow for creating and running an Azure Function, specifically an HTTP-triggered one. Here's a step-by-step breakdown of how you can perform these actions in Azure:

### 1. Establish an Azure App Service (Function App)

An Azure Function App is the hosting container for your individual functions. It's an App Service resource that provides the execution context for your functions.

* **In the Azure Portal:**
    1.  Navigate to the Azure portal.
    2.  In the search bar, type "Function App" and select it.
    3.  Click **Create**.
    4.  Fill out the required details, including:
        * **Subscription:** Your Azure subscription.
        * **Resource Group:** A logical container for your Azure resources. You can create a new one or use an existing one.
        * **Function App name:** A globally unique name for your Function App.
        * **Publish:** Choose "Code" or "Docker Container." For most scenarios, "Code" is the right choice.
        * **Runtime stack:** The programming language you want to use (e.g., .NET, Node.js, Python, Java).
        * **Region:** The Azure region where you want to deploy your app.
        * **Operating System:** Windows or Linux.
        * **Plan type:** This determines the hosting and scaling behavior. The **Consumption (Serverless)** plan is a good starting point as you only pay for the time your functions run.

<img width="1270" height="318" alt="image" src="https://github.com/user-attachments/assets/4e3f3f37-c0f7-48cd-8295-c6b8f8d7618a" />



### 2. Establish the HTTP-Triggered Function

Once you have a Function App, you need to create a function inside it. An HTTP-triggered function is a function that is executed in response to an HTTP request.

* **In the MS VS Code:**
    1.  Navigate to VS code and open an blank directory.later to the extensions, and install python(or any other langugage extension in vs code).
    2.  Similarly install Azure extension and sign into it to bring all the info from your tenant to VS code environment.
    3.  Press F1 while staying in the directory we created last time, in command palette , type azure create function project and go through the steps as asked. this will create basic project files where we have to edit and host function logic files. It'll create a function app in the azure for us to host the actual http trigger.
    4.  Once made sure the function logic is fine, we could publish the code in the form of http trigger to the function app created eariler. You'll need to press F1 to bring up the command palette where we'd type create function only and go through the steps. or just right click on the function app itself and choose DEPLOY TO THE FUNCTION APP option from right click context menu to deploy codes from your default work directory. 
    5.  Provide a name for your function and select an **Authorization level** (e.g., `Function`, `Anonymous`, or `Admin`). `Function` is the default and requires an API key to access the function. `Anonymous` allows anyone to access it without a key.
    6.  Click **Create**. Once created , the functions we created should reflect in azure portal under the same azure app where to deployed the functions to.


<img width="1275" height="242" alt="image" src="https://github.com/user-attachments/assets/16eaf813-e472-43c2-8a6b-55927bd874af" />

<img width="1284" height="485" alt="image" src="https://github.com/user-attachments/assets/cc1eccab-1674-43e7-91e6-bc9e46d4459d" />

### 3. Implementing Azure functions and running them by retrieving their URL

After creating the function, you'll need to write the code. For in-portal development (which is available for certain languages), you can do this directly. The URL for your function is automatically generated.

* **In the Azure Portal:**
    1.  After creating the HTTP-triggered function, you'll be taken to its page.
    2.  In the left menu, under **Developer**, select **Code + Test**. This is where you can see and edit the function's code.
    3.  The code template will already have a basic "Hello World" example. You can modify this as needed.
    4.  To get the URL, click **Get Function URL** at the top.
    5.  This will provide you with the full URL to call your function, including any required function keys if your authorization level is not `Anonymous`.

<<img width="1314" height="507" alt="image" src="https://github.com/user-attachments/assets/4d676756-55f4-48dc-b098-1d4815a11b8b" />


### 4. Run the Azure Function

There are a few ways to run and test your function.

* **In the Azure Portal:**
    1.  On the **Code + Test** page, you can use the built-in **Test/Run** panel to send a test HTTP request. You can configure the HTTP method, headers, and request body.
    2.  Click **Run** to execute the function. The output and logs will be displayed in the panel.

<img width="1034" height="112" alt="image" src="https://github.com/user-attachments/assets/5e411499-1c6a-433c-a12c-213034f2f2ee" />

* **Using the Function URL:**
    1.  Copy the Function URL you retrieved in the previous step.
    2.  You can use a web browser (for `GET` requests), `curl`, Postman, or other API testing tools to send a request to this URL.
    3.  If your function requires a name parameter in the query string, you would append it to the URL, for example: `https://<your_function_app_name>.azurewebsites.net/api/<your_function_name>?name=Azure`.

Here , I passed my name as the name parameter in the query string and below is the output:

<img width="811" height="120" alt="image" src="https://github.com/user-attachments/assets/d2061ad4-6155-4aa4-9347-1490dcaf0119" />

A classic and simple "Hello World" function is the perfect starting point for testing out Azure Functions. It's a great way to understand the core concepts without getting bogged down in complex code.

Here's a breakdown of what the function does and how you can implement it:

### The "Hello World" Function

This function will be triggered by an HTTP request. It will read a name from the request (either from the query string or the request body) and return a personalized greeting. If no name is provided, it will return a generic greeting.

**How it works:**

1.  **Trigger:** It's an **HTTP trigger**, so it's activated when someone sends a request (e.g., using a web browser or a tool like Postman) to its URL.
2.  **Input:** It looks for a parameter named `name`.
3.  **Logic:**
      * If a `name` is found, it constructs a response like "Hello, [Name]\!".
      * If no `name` is found, it returns a generic message, such as "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
4.  **Output:** It sends an HTTP response back to the client.
