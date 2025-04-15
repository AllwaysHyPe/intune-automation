# Deploy-IntuneApp.tests.ps1
# Pester tests for Deploy-IntuneApp.ps1

Describe "Deploy-IntuneApp.ps1" {
    It "Should deploy a new application" {
        # Mock Invoke-IntuneGraphCall
        Mock Invoke-IntuneGraphCall {
            param ($Uri, $Method, $Body) {
                # Assert the parameters passed to Invoke-IntuneGraphCall
                if ($Uri -eq "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps") {
                    $Method | Should -Be "POST"
                    $Body | Should -Not BeNull
                    #  Convert the body and assert
                    $bodyObj = $Body | ConvertFrom-Json
                    $bodyObj.displayName | Should -Be "Test App"
                    $bodyObj.description | Should -Be "Test App Description"
                    $bodyObj.'@odata.type' | Should -Be "Win32"

                    # Return a successful result for app creation
                    @{
                        id = "new-app-id"
                        displayName = "Test App"
                    } | ConvertTo-Json
                } elseif ($Uri -eq "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/new-app-id/assignments") {
                    $Method | Should -Be "POST"
                    $Body | Should -Not BeNull
                     #  Assignments JSON
                }
            }
        }

        # Define parameters for the script
        $params = @{
            DisplayName    = "Test App"
            Description    = "Test App Description"
            AppType        = "Win32"
            AppInstallJson   = '{}' #  Minimal
            AssignmentsJson = '{}' # Minimal
        }

        # Run the script
        $output = Invoke-Command -ScriptBlock ${function:Deploy-IntuneApp} -Parameter $params

        # Assert the output.  Adjust this to match the actual output of your script.
        $output | Should -Be "Successfully created application: Test App (ID: new-app-id)`nSuccessfully created assignments for application: Test App"
    }

      It "Should handle errors from Invoke-IntuneGraphCall during app creation" {
        Mock Invoke-IntuneGraphCall {
            Throw "Failed to create app"
        }
        $params = @{
            DisplayName    = "Test App"
            Description    = "Test App Description"
            AppType        = "Win32"
            AppInstallJson   = '{}'
            AssignmentsJson = '{}'
        }
        { Invoke-Command -ScriptBlock ${function:Deploy-IntuneApp} -Parameter $params } | Should Throw -Message "Failed to create app"
    }

     It "Should handle errors from Invoke-IntuneGraphCall during assignment creation" {
        # Mock Invoke-IntuneGraphCall to succeed on app creation, fail on assignment
        Mock Invoke-IntuneGraphCall {
             param ($Uri, $Method, $Body) {
                if ($Uri -eq "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps") {
                    # Return a successful result for app creation
                    @{
                        id = "new-app-id"
                        displayName = "Test App"
                    } | ConvertTo-Json
                }
                elseif ($Uri -eq "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/new-app-id/assignments") {
                     Throw "Failed to create assignments"
                }
             }
        }
        $params = @{
            DisplayName    = "Test App"
            Description    = "Test App Description"
            AppType        = "Win32"
            AppInstallJson   = '{}'
            AssignmentsJson = '{}'
        }
        { Invoke-Command -ScriptBlock ${function:Deploy-IntuneApp} -Parameter $params } | Should Throw -Message "Failed to create assignments"
    }
}
