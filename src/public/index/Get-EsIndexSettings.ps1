function Get-EsIndexSettings {
  <#
  .SYNOPSIS
    Get the currently configured Index configuration on the ElasticSearch server for the specified index name
  .DESCRIPTION
    Get the configuration of the specified Index from the nomiated ElasticSearch server.

    Optionally supports Authentication.
  .PARAMETER EsUrl
    Base URL for your ElasticSearch server/cluster
  .PARAMETER IndexName
    Name of ElasticSearch Index to get current information and configuration of.
  .PARAMETER EsCreds
    PSCredential object containing username and password to access ElasticSearch
  .INPUTS
    None
  .OUTPUTS
    Information about the specified index on ElasticSearch Cluster
  .EXAMPLE
    Retrieve status and configuration about an index named MyIndex without authentication

    PS C:\> $EsIndex = Get-EsIndex -EsUrl http://192.168.1.10:9200 -IndexName 'MyIndex'
  .LINK
    https://github.com/IPSecMSSP/Elastic.Helper
  #>

  [CmdletBinding()]

  param (
    [string] [Parameter(Mandatory=$true)] $ESUrl,
    [string] [Parameter(Mandatory=$true)] $IndexName,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  $Method = 'GET'
  $Uri = [io.path]::Combine($ESUrl, $IndexName, "_settings")
  if ($EsCreds) {
    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -User $EsCreds.UserName -Password $EsCreds.Password -SkipCertificateCheck
  } else {
    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -SkipCertificateCheck
  }
}
