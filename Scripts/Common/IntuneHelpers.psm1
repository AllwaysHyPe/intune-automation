# IntuneHelpers.psm1
# PowerShell module for reusable Intune functions

function Get-IntuneAccessToken {
    <#
    .SYNOPSIS
    Gets an access token for the Microsoft Graph API using a managed identity.
    .DESCRIPTION
    Retrieves an access token to authenticate with the Microsoft Graph API.  This function
    is designed to be used in an Azure environment with a managed identity.
    .EXAMPLE
    $token = Get-IntuneAccessToken
    #>
    $uri = "https://management.azure.com/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://graph.microsoft.com"
    $headers = @{
        Metadata = "true"
    }

    try {
        $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -Identity
        return $response.access_token
    }
    catch {
        Write-Error "Failed to retrieve access token: $($_.Exception.Message)"
        throw
    }
}

function Invoke-IntuneGraphCall {
    <#
    .SYNOPSIS
    Wraps Invoke-RestMethod for simplified calls to the Microsoft Graph API.
    .DESCRIPTION
    This function simplifies making requests to the Microsoft Graph API, handling
    authentication and error handling.
    .PARAMETER Uri
    The URI of the Graph API endpoint.
    .PARAMETER Method
    The HTTP method to use (e.g., GET, POST, PATCH, DELETE).
    .PARAMETER Body
    The body of the request (for POST, PATCH).  Should be a JSON string.
    .PARAMETER AccessToken
     (Optional) The access token to use.  If not provided, Get-IntuneAccessToken is called.
    .EXAMPLE
    $result = Invoke-IntuneGraphCall -Uri "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices" -Method "GET"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Uri,

        [Parameter(Mandatory = $true)]
        [string] $Method,

        [Parameter()]
        [string] $Body,

        [Parameter()]
        [string] $AccessToken
    )

    if (-not $AccessToken) {
        $AccessToken = Get-IntuneAccessToken
    }

    $headers = @{
        "Authorization" = "Bearer $($AccessToken)"
        "Content-Type"  = "application/json"
    }

    $params = @{
        Uri     = $Uri
        Headers = $headers
        Method  = $Method
        ErrorAction = 'Stop'
    }

    if ($Body) {
        $params.Body = $Body
    }

    try {
        $response = Invoke-RestMethod @params
        return $response
    }
    catch {
        Write-Error "Graph API call failed: $($_.Exception.Message) - $($_.Exception.Response.Content)"
        throw
    }
}
