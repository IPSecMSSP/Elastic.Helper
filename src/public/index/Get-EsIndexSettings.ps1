function Get-EsIndexSettings {

    [CmdletBinding()]

    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $IndexName
    )

    $Method = 'GET'
    $Uri = [io.path]::Combine($ESUrl, $IndexName, "_settings")

    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json'
}
