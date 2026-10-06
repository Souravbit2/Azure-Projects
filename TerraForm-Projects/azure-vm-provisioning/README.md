# Azure VM Provisioning

This project provides a Terraform configuration for provisioning an Azure Virtual Machine along with the necessary networking components.

## Project Structure

- **main.tf**: Contains the main configuration for provisioning the Azure virtual machine, including resource definitions for the virtual machine, network interface, and public IP address.
- **variables.tf**: Defines the input variables for the Terraform configuration, specifying types and default values for variables such as VM name, resource group name, location, and size.
- **outputs.tf**: Specifies the output values that Terraform will display after the resources are created, including the public IP address of the virtual machine and its resource ID.

## Prerequisites

- An Azure account with sufficient permissions to create resources.
- Terraform installed on your local machine.

## Getting Started

1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd azure-vm-provisioning
   ```

2. **Initialize Terraform**:
   Run the following command to initialize the Terraform configuration:
   ```
   terraform init
   ```

3. **Plan the deployment**:
   To see what resources will be created, run:
   ```
   terraform plan
   ```

4. **Apply the configuration**:
   To provision the resources, execute:
   ```
   terraform apply
   ```

   Confirm the action when prompted.

## Outputs

After the resources are created, Terraform will display output values such as the public IP address of the virtual machine and its resource ID.

## Cleanup

To remove all resources created by this configuration, run:
```
terraform destroy
```

## License

This project is licensed under the MIT License.