import os
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

# No credentials needed! The DefaultAzureCredential will
# automatically use the managed identity when running on Azure.

# Get the storage account URL from an environment variable (best practice)
storage_account_url = os.environ.get("STORAGE_ACCOUNT_URL")
container_name = "my-app-data"
blob_name = "example.txt"

# Use the managed identity to get a credential
credential = DefaultAzureCredential()

# Create a BlobServiceClient using the managed identity credential
blob_service_client = BlobServiceClient(account_url=storage_account_url, credential=credential)

# Get a client for the specific container
container_client = blob_service_client.get_container_client(container_name)

# Download and print the content of the blob
try:
    blob_client = container_client.get_blob_client(blob_name)
    stream = blob_client.download_blob()
    print(stream.readall().decode("utf-8"))
except Exception as e:
    print(f"Error accessing blob: {e}")