# Intune Automation

This repository provides a set of PowerShell scripts, Pester tests, and a GitHub Actions workflow to automate Microsoft Intune management. It enables environment normalization, scalability, and team collaboration, following an infrastructure-as-code approach.

## Problem

Manually managing Intune configurations through the console is time-consuming, error-prone, and doesn't scale well. It often leads to inconsistent configurations across environments and makes it difficult to track and version changes.

## Solution

This repository provides a solution to automate Intune management by:

* Treating Intune configurations as code using PowerShell scripts.
* Ensuring consistency and repeatability through automation.
* Validating configurations with Pester tests.
* Automating deployments with GitHub Actions.
* Using managed identities for secure authentication.

This approach enables you to manage Intune at scale, reduce errors, and collaborate effectively with your team.

## Repository Structure

IntuneAutomation/
├── .github/                  # GitHub Actions workflows
│   └── workflows/
│       └── deploy-intune.yml  # Workflow for deploying Intune configurations
├── DSC/                      # (Optional) DSC Configurations
│   └── IntuneBaseline/
│       └── IntuneBaseline.ps1 # DSC Configuration script
├── Scripts/                  # PowerShell scripts for Intune management
│   ├── ConfigurationProfiles/
│   │   └── New-IntuneConfigurationProfile.ps1
│   ├── CompliancePolicies/
│   │   └── New-IntuneCompliancePolicy.ps1
│   ├── Applications/
│   │   └── Deploy-IntuneApp.ps1
│   └── Common/             # Reusable functions and modules
│       └── IntuneHelpers.psm1
├── Tests/                    # Pester tests
│   ├── ConfigurationProfiles/
│   │   └── New-IntuneConfigurationProfile.tests.ps1
│   ├── CompliancePolicies/
│   │   └── New-IntuneCompliancePolicy.tests.ps1
│   ├── Applications/
│   │   └── Deploy-IntuneApp.tests.ps1
│   └── Common/
│       └── IntuneHelpers.tests.ps1
└── README.md

## Explanation of Key Directories and Files

* **.github/workflows/:**
    * `deploy-intune.yml`: This is the GitHub Actions workflow file that orchestrates the deployment of your Intune configurations. It will:
        * Check out the code.
        * Authenticate to Azure using a managed identity.
        * Run Pester tests.
        * Execute the PowerShell scripts in the `Scripts/` directory to apply the configurations.
* **DSC/:**
    * This directory is optional and would contain your DSC configuration scripts if you choose to use DSC for Intune management.
    * `IntuneBaseline/IntuneBaseline.ps1`: An example DSC configuration file that defines the desired state of your Intune environment (e.g., baseline security settings).
* **Scripts/:**
    * This directory contains PowerShell scripts for managing Intune configurations using `Invoke-RestMethod`.
    * Scripts are organized by Intune workload (e.g., Configuration Profiles, Compliance Policies, Applications) for better maintainability.
    * `Common/IntuneHelpers.psm1`: This module contains reusable functions that are used by your other scripts (e.g., functions for authenticating to the Graph API, handling errors, retrieving common data).
* **Tests/:**
    * This directory contains Pester test files that correspond to the scripts in the `Scripts/` directory.
    * The test files verify the behavior of your scripts and ensure they are working as expected.
* **README.md:**
    * This file contains documentation for your repository.
* **LICENSE:**
    * This file contains the license information for your repository.

## Usage

### Prerequisites

* Azure subscription
* Intune tenant
* GitHub repository
* PowerShell 7
* Pester

### Getting Started

1.  Clone this repository:

    ```bash
    git clone [https://github.com/your-repo/intune-automation.git](https://github.com/your-repo/intune-automation.git)
    ```

2.  Configure your Azure credentials:
    * Ensure you have a system-assigned managed identity enabled on the Azure resource where the scripts will run (e.g., an Azure Automation account or a virtual machine).
    * Grant the managed identity the necessary permissions to access the Microsoft Graph API for Intune.

3.  Configure the GitHub Actions workflow:
    * Add your Azure subscription ID as a secret in your GitHub repository.
    * Ensure the `deploy-intune.yml` workflow is configured correctly to use the managed identity.

4.  Write PowerShell scripts to manage your Intune configurations using `Invoke-RestMethod`.  See the `Scripts/` directory for examples.

5.  Write Pester tests to validate your scripts.  See the `Tests/` directory for examples.

6.  Push your changes to the `main` branch to trigger the GitHub Actions workflow.

## Best Practices

* **Infrastructure as Code:** Treat your Intune configurations as code to ensure consistency, repeatability, and version control.
* **Modularization:** Use PowerShell modules to organize your code and promote reusability.
* **Testing:** Write Pester tests to validate your scripts and prevent errors.
* **Automation:** Use GitHub Actions to automate the deployment of your Intune configurations.
* **Security:** Use managed identities for authentication to avoid storing credentials in your code.
* **Documentation:** Keep your scripts and workflows well-documented.
* **Collaboration:** Use Git and GitHub to collaborate with your team and track changes.
