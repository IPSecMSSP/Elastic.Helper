# Get the current pipeline definition
function Get-EsPipeline {
  <#
  .SYNOPSIS
      Get the currently configured Pipeline configuration on the ElasticSearch server for the specified index name
  .DESCRIPTION
      Get the configuration of the specified Pipeline from the nomiated ElasticSearch server.

      Optionally supports Authentication.
  .PARAMETER EsUrl
      Base URL for your ElasticSearch server/cluster
  .PARAMETER Pipeline
      Name of ElasticSearch Pipeline to get current configuration of.
  .PARAMETER EsCreds
      PSCredential object containing username and password to access ElasticSearch
  .INPUTS
      None
  .OUTPUTS
      Configuration of specified pipeline on ElasticSearch Cluster
  .EXAMPLE
      Retrieve status and configuration about an pipeline named MyPipeline without authentication

      PS C:\> $EsPipeline = Get-EsPipeline -EsUrl http://192.168.1.10:9200 -Pipeline 'MyPipeline'
  .LINK
      https://github.com/IPSecMSSP/Elastic.Helper
  #>

  [CmdletBinding()]

  param (
    [string] [Parameter(Mandatory=$true)] $ESUrl,
    [string] [Parameter(Mandatory=$true)] $Pipeline,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  $Method = 'GET'
  $Uri = [io.path]::Combine($ESUrl, "_ingest/pipeline/", $Pipeline)
  if ($EsCreds) {
    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -User $EsCreds.Username -Password $EsCreds.Password -SkipCertificateCheck | ConvertFrom-Json -Depth 10
  } else {
    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -SkipCertificateCheck | ConvertFrom-Json -Depth 10
  }
}
