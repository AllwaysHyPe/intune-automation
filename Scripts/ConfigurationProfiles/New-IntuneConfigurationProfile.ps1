# New-IntuneConfigurationProfile.ps1
# Creates a new Intune Configuration Profile

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $DisplayName,

    [Parameter(Mandatory = $true)]
    [string] $Description,

    [Parameter(Mandatory = $true)]
    [string] $Platform,  # e.g., "windows10", "ios"

    [Parameter(Mandatory = $true)]
    [string] $SettingsJson # JSON representation of the profile settings
)

# Construct the URI
$uri = "https://graph.microsoft.com/beta/deviceManagement/deviceConfigurations"

# Construct the body
$body = @{
    displayName = $DisplayName
    description = $Description
    platform = $Platform
    #  Add settings here.  This is just an example.  The actual structure
    #  depends on the profile type.  You'll need to adapt this.
    #  settings = ConvertFrom-Json $SettingsJson
} | ConvertTo-Json -Depth 3

try {
    $result = Invoke-IntuneGraphCall -Uri $uri -Method "POST" -Body $body
    Write-Host "Successfully created configuration profile: $($result.displayName) (ID: $($result.id))"
}
catch {
    Write-Error "Failed to create configuration profile: $($_.Exception.Message)"
    exit 1
}
