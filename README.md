# DLP Exceptions Management Deployment

This repository deploys an Azure‑native DLP Exceptions Management system that includes an Azure Function App and Azure Key Vault for managing secrets. Click the button below to deploy the solution in your Azure subscription and resource group.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https://raw.githubusercontent.com/<YourGitHubUser>/<YourRepo>/main/main.bicep)

## Deployment Instructions

1. **Click the button above.**  
   This will open the Azure Portal's custom deployment screen.
   
2. **Select your Azure subscription** and **resource group** (or create a new one).
   
3. **Enter the required parameters** when prompted:
   - **Function App Name:** Provide a unique name for your Azure Function App.
   - **Key Vault Name:** Specify a globally unique name for your Azure Key Vault.
   - **Location:** Defaults to the resource group location.

4. **Review and Create.**  
   Once you review the settings, click on *Create* to deploy the resources.

## Next Steps

In subsequent phases, we will add additional modules such as the Azure SQL Database with temporal tables, change detection triggers, and further configuration of the Function App.
