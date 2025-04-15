# Azure DLP Exceptions Management

A production‑grade, Azure‑native system for managing DLP exceptions with a focus on modern DevSecOps practices. This solution leverages Azure SQL Database with system‑versioned temporal tables to store DLP exceptions, Azure Key Vault to secure sensitive secrets, and—eventually—Azure Functions to process change events and drive automated policy updates. The repository also includes a one‑click deployment button for streamlined provisioning in Azure.

Overview

This project is designed to automate the management of DLP (Data Loss Prevention) exceptions with an architecture that:

    Stores DLP Exceptions: Utilizes an Azure SQL Database featuring system‑versioned temporal tables to record and track changes.

    Secures Sensitive Data: Employs Azure Key Vault to securely store connection strings, certificates, and application secrets.

    Automates Business Logic: Integrates with Azure Functions (planned) to react to data changes and automate DLP policy updates, certificate generation, and more.

    DevSecOps Focus: Demonstrates production‑grade practices with Infrastructure as Code (via Bicep), a one‑click deployment process, and plans for CI/CD integration.

Architecture

The solution is composed of several key components:

    Azure SQL Database with Temporal Tables:
    Stores DLP exceptions in a table that automatically maintains history, enabling you to track changes over time.

    Azure Key Vault:
    Manages secrets and certificates securely. It serves as a centralized repository for sensitive configuration data.

    Azure Functions (Planned):
    Will react to data changes through one of several mechanisms (SQL Change Tracking, CDC, SQL Triggers with Service Bus) to implement business logic such as policy updates and certificate automation.

    One‑Click Deployment:
    Deploy the entire solution into your Azure subscription quickly using a single deployment button.
