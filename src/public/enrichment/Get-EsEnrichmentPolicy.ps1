# Get the current enrichment policy definition
function Get-EsEnrichmentPolicy {

  [CmdletBinding()]

  param (
      [string] [Parameter(Mandatory=$true)] $ESUrl,
      [string] [Parameter(Mandatory=$true)] $Policy
  )

  $Method = 'GET'
  $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy)

  Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json'

}
