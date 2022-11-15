# Get the current enrichment policy definition
function Get-EsEnrichmentPolicy {
  <#
  .SYNOPSIS
      Get the currently configured Enrichment Policy configuration on the ElasticSearch server for the specified policy name
  .DESCRIPTION
      Get the configuration of the specified Enrichment Policy from the nomiated ElasticSearch server.

      Optionally supports Authentication.
  .PARAMETER EsUrl
      Base URL for your ElasticSearch server/cluster
  .PARAMETER Policy
      Name of ElasticSearch Enrichment Policy to get current configuration of.
  .PARAMETER EsCreds
      PSCredential object containing username and password to access ElasticSearch
  .INPUTS
      None
  .OUTPUTS
      Definition of current Enrichment Policy on ElasticSearch Cluster
  .EXAMPLE
      Retrieve Enrichment Policy named MyEnrichmentPolicy without authentication

      PS C:\> $EnrichPol = Get-EsEnrichmentPolicy -EsUrl http://192.168.1.10:9200 -Policy 'MyEnrichmentPolicy'
  .LINK
      https://github.com/IPSecMSSP/Elastic.Helper
  #>

  [CmdletBinding()]

  param (
    [string] [Parameter(Mandatory=$true)] $ESUrl,
    [string] [Parameter(Mandatory=$true)] $Policy,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  $Method = 'GET'
  $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy)

  if ($EsCreds){
    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -User $EsCreds.Username -Password $EsCreds.Password -SkipCertificateCheck | ConvertFrom-Json -Depth 10
  } else {
    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -SkipCertificateCheck | ConvertFrom-Json -Depth 10
  }

}
