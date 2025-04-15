# New-IntuneCompliancePolicy.tests.ps1
# Pester tests for New-IntuneCompliancePolicy.ps1

Describe "New-IntuneCompliancePolicy.ps1" {
    It "Should create a new compliance policy" {
        # Mock Invoke-IntuneGraphCall
        Mock Invoke-IntuneGraphCall {
            param ($Uri, $Method, $Body) {
                # Assert the parameters passed to Invoke-IntuneGraphCall
                $Uri | Should -Be "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies"
                $Method | Should -Be "POST"
                $Body | Should -Not BeNull

                #  Convert the body back to a PowerShell object and assert properties
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.displayName | Should -Be "Test Compliance Policy"
                $bodyObj.description | Should -Be "Test Compliance Description"
                $bodyObj.platform | Should -Be "windows10"
                # Add assertions for compliance settings

                # Return a successful result
                @{
                    id = "new-compliance-policy-id"
                    displayName = "Test Compliance Policy"
                } | ConvertTo-Json
            }
        }

        # Define parameters for the script
        $params = @{
            DisplayName            = "Test Compliance Policy"
            Description            = "Test Compliance Description"
            Platform               = "windows10"
            DeviceComplianceSettingsJson = '{}' # Minimal JSON for the test
        }

        # Run the script
        $output = Invoke-Command -ScriptBlock ${function:New-IntuneCompliancePolicy} -Parameter $params

        # Assert the output
        $output | Should -Be "Successfully created compliance policy: Test Compliance Policy (ID: new-compliance-policy-id)"
    }

    # Add more test cases, e.g., for error handling
    It "Should handle errors from Invoke-IntuneGraphCall" {
        Mock Invoke-IntuneGraphCall {
            Throw "Failed to connect to Graph"
        }
        $params = @{
            DisplayName            = "Test Compliance Policy"
            Description            = "Test Compliance Description"
            Platform               = "windows10"
            DeviceComplianceSettingsJson = '{}'
        }
        { Invoke-Command -ScriptBlock ${function:New-IntuneCompliancePolicy} -Parameter $params } | Should Throw -Message "Failed to connect to Graph"
    }
}