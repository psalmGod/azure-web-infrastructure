# Azure Web Infrastructure Provisioning with Terraform

## Overview

This project provisions a web infrastructure stack on Azure using Terraform. It includes:

- Virtual Network with subnets for web and database tiers.
- Network Security Groups (NSGs) with appropriate rules.
- Web tier Virtual Machines (VMs) in an Availability Set.
- Database tier VM.
- Azure Load Balancer and Application Gateway.
- Azure SQL Database.
- Azure Key Vault for secret management.
- Azure Backup for VMs and SQL Database.
- Azure Security Center configuration.

## Prerequisites

- **Azure Subscription**: An active Azure account.
- **Terraform**: Installed on your local machine. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- **Azure CLI**: Installed and logged in. [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- **Git**: For cloning the repository.

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/mattmpe09/azure-web-infrastructure.git
cd azure-web-infrastructure
```
### 2. Authenticate with Azure
Ensure you're logged in to Azure CLI:

```bash
az login
```
### 3. Initialize Terraform

```bash
terraform init
```
### 4. Review and Set Variables
Open variables.tf to review default values.

**Sensitive Variables:**

**admin_password:** Admin password for VMs.
**sql_admin_password:** Admin password for SQL Server.

### Create a terraform.tfvars file to set these variables (DO NOT COMMIT this file):
```hcl
admin_password     = "YourSecurePassword123!"
sql_admin_password = "YourSecureSQLPassword123!"
```
### 5. Plan the Deployment
Review the resources to be created:
```bash
terraform plan
```
## 6. Apply the Configuration

Deploy the infrastructure:

```bash
terraform apply
```
Type **yes** to confirm.

## 7. Post-Deployment

**Outputs**: After deployment, Terraform will output important information like public IP addresses.

**Access Resources**:

- **Load Balancer**: Use `web_lb_public_ip` to access the web application.
- **Application Gateway**: Use `app_gateway_public_ip` for the same.

---

## Infrastructure Details

### Virtual Network and Subnets

- **Address Space**: `10.0.0.0/16`
- **Web Subnet**: `10.0.1.0/24`
- **Database Subnet**: `10.0.2.0/24`

### Network Security Groups

- **Web NSG**: Allows inbound HTTP (port 80) and HTTPS (port 443).
- **Database NSG**: Allows inbound SQL (port 1433) from the web subnet.

### Virtual Machines

#### Web Tier VMs:

- **Count**: 2
- **OS**: Windows Server 2019
- **Size**: `Standard_D2s_v3`
- **Disk**: Premium SSD, 128 GB
- **Availability Set**: Yes

#### Database Tier VM:

- **OS**: Windows Server 2019
- **Size**: `Standard_D4s_v3`
- **Disk**: Premium SSD, 256 GB

### Load Balancer and Application Gateway

#### Load Balancer:

- **SKU**: Standard
- **Function**: Distributes traffic on port 80 to web VMs.

#### Application Gateway:

- **SKU**: `Standard_v2`
- **Function**: Fronts web VMs with basic routing rules.

### Azure SQL Database

- **Server**: New server in the same region.
- **Database**: `mydatabase`
- **Pricing Tier**: Standard S0

### Azure Key Vault

- Stores admin passwords for VMs and SQL Server.
- Ensures secrets are managed securely.

### Azure Backup

- Recovery Services Vault created.
- Daily backups of VMs with 7-day retention.

### Azure Security Center

- Standard tier enabled for VMs and SQL Servers.
- Security contact configured.

---

## Cleanup

To destroy all resources when done:

```bash
terraform destroy
```
Type **yes** to confirm.

## Notes
* **Security:** Do not commit sensitive information like passwords to version control.
* **Costs:** Be aware of Azure costs associated with running these resources.

## Troubleshooting
* Ensure you have the necessary Azure permissions.
* Check for any typos or syntax errors in .tf files.
* Use terraform validate to check the configuration.

## References

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Terraform Samples](https://github.com/Azure/terraform)

  
---

## **Final Notes**

- **Sensitive Data**: Ensure that `terraform.tfvars` or any files containing sensitive data are not committed to GitHub. Add them to `.gitignore`.

- **Testing**: Before pushing to GitHub, run `terraform validate` and `terraform fmt` to validate and format your code.

- **Version Control**: Commit your changes with meaningful messages.

```bash
git add .
git commit -m "Add infrastructure provisioning with Terraform"
git push origin main
```

