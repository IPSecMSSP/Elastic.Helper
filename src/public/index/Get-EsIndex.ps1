# Get index info

function Get-EsIndex {
  <#
  .SYNOPSIS
      Get the currently configured Index configuration on the ElasticSearch server for the specified index name
  .DESCRIPTION
      Get the configuration of the specified Index from the nomiated ElasticSearch server.

      Optionally supports Authentication.
  .PARAMETER EsUrl
      Base URL for your ElasticSearch server/cluster
  .PARAMETER EsIndex
      Name of ElasticSearch Index to get current information and configuration of.
  .PARAMETER EsCreds
      PSCredential object containing username and password to access ElasticSearch
  .INPUTS
      None
  .OUTPUTS
      Information about the specified index on ElasticSearch Cluster
  .EXAMPLE
      Retrieve status and configuration about an index named MyIndex without authentication

      PS C:\> $EsIndex = Get-EsIndex -EsUrl http://192.168.1.10:9200 -EsIndex 'MyIndex'
  .LINK
      https://github.com/jberkers42/Elastic-Helper
  #>

  [CmdletBinding()]

  param(
    [string] [Parameter(Mandatory=$true)] $ESUrl,
    [string] [Parameter(Mandatory=$true)] $EsIndex,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  $Method = 'GET'
  $Uri = [io.path]::Combine($ESUrl, $EsIndex, "_settings")

  if ($EsCreds) {
    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -User $EsCreds.UserName -Password $EsCreds.Password  -SkipCertificateCheck| ConvertFrom-Json -Depth 8
  } else {
    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -SkipCertificateCheck | ConvertFrom-Json -Depth 8
  }
}
