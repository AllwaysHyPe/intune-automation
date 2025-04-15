# New-IntuneCompliancePolicy.ps1
# Creates a new Intune Compliance Policy

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $DisplayName,

    [Parameter(Mandatory = $true)]
    [string] $Description,

    [Parameter(Mandatory = $true)]
    [string] $Platform,  # e.g., "windows10", "ios"

    [Parameter(Mandatory = $true)]
    [string] $DeviceComplianceSettingsJson # JSON representation of compliance settings
)

# Construct the URI
$uri = "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies"

# Construct the body
$body = @{
    displayName = $DisplayName
    description = $Description
    platform = $Platform
     #  Add settings here.  This is just an example.  The actual structure
    #  depends on the policy type.  You'll need to adapt this.
    #  settings = ConvertFrom-Json $DeviceComplianceSettingsJson
} | ConvertTo-Json -Depth 3

try {
    $result = Invoke-IntuneGraphCall -Uri $uri -Method "POST" -Body $body
    Write-Host "Successfully created compliance policy: $($result.displayName) (ID: $($result.id))"
}
catch {
    Write-Error "Failed to create compliance policy: $($_.Exception.Message)"
    exit 1
}