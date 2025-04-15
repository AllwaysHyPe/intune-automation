# Intune Automation

This repository provides a set of PowerShell scripts, Pester tests, and a GitHub Actions workflow to automate Intune management, promoting environment normalization, scalability, and team collaboration.

## Repository Structure

IntuneAutomation/├── .github/                  # GitHub Actions workflows│   └── workflows/│       └── deploy-intune.yml  # Workflow for deploying Intune configurations├── DSC/                      # (Optional) DSC Configurations│   └── IntuneBaseline/│       └── IntuneBaseline.ps1 # DSC Configuration script├── Scripts/                  # PowerShell scripts for Intune management│   ├── ConfigurationProfiles/│   │   └── New-IntuneConfigurationProfile.ps1│   ├── CompliancePolicies/│   │   └── New-IntuneCompliancePolicy.ps1│   ├── Applications/│   │   └── Deploy-IntuneApp.ps1│   └── Common/             # Reusable functions and modules│       └── IntuneHelpers.psm1├── Tests/                    # Pester tests│   ├── ConfigurationProfiles/│   │   └── New-IntuneConfigurationProfile.tests.ps1│   ├── CompliancePolicies/│   │   └── New-IntuneCompliancePolicy.tests.ps1│   ├── Applications/│   │   └── Deploy-IntuneApp.tests.ps1│   └── Common/│       └── IntuneHelpers.tests.ps1├── README.md                 # Project documentation└── LICENSE                   # (Optional) License information
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
    * It is crucial to maintain a test file for each script to ensure the quality and reliability of your Intune automation.
* **README.md:**
    * This file contains documentation for your repository.
* **LICENSE:**
    * This file contains the license information for your repository.

## Best Practices and Considerations

* **Modularization:**
    * Use PowerShell modules (like `IntuneHelpers.psm1`) to encapsulate reusable functions and improve code organization.
    * This promotes a more modular and maintainable codebase.
* **Error Handling:**
    * Implement robust error handling in your PowerShell scripts using `try-catch` blocks.
    * Log errors appropriately and provide informative messages.
* **Pester Testing:**
    * Write comprehensive Pester tests for all your PowerShell scripts.
    * Follow best practices for writing Pester tests, such as using `Describe`, `Context`, and `It` blocks to organize your tests.
    * Use mocks and stubs to isolate your code and test it in a controlled environment.
* **GitHub Actions Workflow:**
    * The GitHub Actions workflow is configured to:
        * Run Pester tests before deploying any changes.
        * Use a managed identity for authentication.
        * Follow the principle of least privilege when granting permissions to the managed identity.
        * Use environment variables and secrets to store sensitive information.
* **Documentation:**
    * Keep the `README.md` file up-to-date with the latest information about the repository.
    * Document your scripts and functions using PowerShell comments.
* **Security:**
    * Avoid storing any sensitive information (e.g., passwords, API keys) in your scripts or in your GitHub repository.
    * Use managed identities for authentication.
* **Version Control:**
    * Use Git effectively to track changes to your code.
    * Use branches for development and feature work, and merge them into the main branch when they are ready.
    * Use pull requests for code review and collaboration.

By following this structure and these best practices, you can create a robust, scalable, and maintainable repository for your Intune automation projects. This will not only help you manage your Intune environments more effectively but also promote collaboration and knowledge sharing within your team.
