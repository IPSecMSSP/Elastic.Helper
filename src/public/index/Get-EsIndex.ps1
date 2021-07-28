# Get index info

function Get-EsIndex {

  [CmdletBinding()]

  param(
      [string] [Parameter(Mandatory=$true)] $ESUrl,
      [string] [Parameter(Mandatory=$true)] $EsIndex
  )

  $Method = 'GET'
  $Uri = [io.path]::Combine($ESUrl, $EsIndex, "_settings")

  Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' | ConvertFrom-Json -Depth 8
}
