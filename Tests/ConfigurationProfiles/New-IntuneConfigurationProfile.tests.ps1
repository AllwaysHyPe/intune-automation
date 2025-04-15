# New-IntuneConfigurationProfile.tests.ps1
# Pester tests for New-IntuneConfigurationProfile.ps1

Describe "New-IntuneConfigurationProfile.ps1" {
    It "Should create a new configuration profile" {
        # Mock Invoke-IntuneGraphCall
        Mock Invoke-IntuneGraphCall {
            param ($Uri, $Method, $Body) {
                # Assert the parameters passed to Invoke-IntuneGraphCall
                $Uri | Should -Be "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"
                $Method | Should -Be "POST"
                $Body | Should -Not BeNull

                #  Convert the body back to a PowerShell object and assert properties
                $bodyObj = $Body | ConvertFrom-Json
                $bodyObj.displayName | Should -Be "Test Profile"
                $bodyObj.description | Should -Be "Test Description"
                $bodyObj.platform | Should -Be "windows10"
                #  Add more assertions for the settings

                # Return a successful result
                @{
                    id = "new-profile-id"
                    displayName = "Test Profile"
                } | ConvertTo-Json
            }
        }

        # Define parameters for the script
        $params = @{
            DisplayName  = "Test Profile"
            Description  = "Test Description"
            Platform     = "windows10"
            SettingsJson = '{}' #  Minimal JSON for the test
        }

        # Run the script
        $output = Invoke-Command -ScriptBlock ${function:New-IntuneConfigurationProfile} -Parameter $params

        # Assert the output
        $output | Should -Be "Successfully created configuration profile: Test Profile (ID: new-profile-id)"
    }

    # Add more test cases, e.g., for error handling
    It "Should handle errors from Invoke-IntuneGraphCall" {
         Mock Invoke-IntuneGraphCall {
            Throw "Failed to connect to Graph"
         }
        $params = @{
            DisplayName  = "Test Profile"
            Description  = "Test Description"
            Platform     = "windows10"
            SettingsJson = '{}'
        }
         # Run the script and assert that it throws the expected error
        { Invoke-Command -ScriptBlock ${function:New-IntuneConfigurationProfile} -Parameter $params } | Should Throw -Message "Failed to connect to Graph"
    }
}