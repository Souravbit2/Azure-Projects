import os
import logging
import azure.functions as func
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("Processing blob read request...")

    storage_account_url = os.environ["STORAGE_ACCOUNT_URL"]
    container_name = "my-app-data"
    blob_name = "example.txt"

    try:
        credential = DefaultAzureCredential()
        blob_service_client = BlobServiceClient(account_url=storage_account_url, credential=credential)
        blob_client = blob_service_client.get_container_client(container_name).get_blob_client(blob_name)
        content = blob_client.download_blob().readall().decode("utf-8")
        return func.HttpResponse(content, status_code=200)
    except Exception as e:
        return func.HttpResponse(f"Error: {e}", status_code=500)
