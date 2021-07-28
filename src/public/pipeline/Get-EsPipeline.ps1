# Get the current pipeline definition
function Get-EsPipeline {

  [CmdletBinding()]

  param (
      [string] [Parameter(Mandatory=$true)] $ESUrl,
      [string] [Parameter(Mandatory=$true)] $Pipeline
  )

  $Method = 'GET'
  $Uri = [io.path]::Combine($ESUrl, "_ingest/pipeline/", $Pipeline)

  Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json'
}
