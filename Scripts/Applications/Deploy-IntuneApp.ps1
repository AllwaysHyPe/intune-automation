# Deploy-IntuneApp.ps1
# Deploys an Intune application

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $DisplayName,

    [Parameter(Mandatory = $true)]
    [string] $Description,

    [Parameter(Mandatory = $true)]
    [string] $AppType, # e.g., "Win32", "iOS", "Android"

    [Parameter(Mandatory = $true)]
    [string] $AppInstallJson, # JSON representation of app installation details

    [Parameter(Mandatory = $true)]
    [string] $AssignmentsJson # JSON representation of the app assignments
)

# Construct the URI
$uri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps"

# Construct the body of the request.  This is a complex object,
# and the structure varies significantly based on the app type.
# This is a placeholder example.  You MUST adapt this to the specific
# app type you are deploying.
$body = @{
    "@odata.type" = $AppType # e.g., "#microsoft.graph.win32LobApp"
    displayName     = $DisplayName
    description     = $Description
    # Example of a generic property.  Add more properties as needed
    #installInformation = ConvertFrom-Json $AppInstallJson
} | ConvertTo-Json -Depth 5

try {
    # Create the app
    $appResult = Invoke-IntuneGraphCall -Uri $uri -Method "POST" -Body $body

    $appId = $appResult.id
    Write-Host "Successfully created application: $($appResult.displayName) (ID: $($appId))"

    # Create the assignments.  The structure of this JSON also varies.
    $assignmentsUri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$appId/assignments"
    $assignmentsBody = $AssignmentsJson #  JSON representing the assignments
    $assignmentsResult = Invoke-IntuneGraphCall -Uri $assignmentsUri -Method "POST" -Body $assignmentsBody
    Write-Host "Successfully created assignments for application: $($appResult.displayName)"


}
catch {
    Write-Error "Failed to deploy application: $($_.Exception.Message)"
    exit 1
}