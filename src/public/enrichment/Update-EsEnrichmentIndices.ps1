# Rebuild Enrichment Indices
function Update-EsEnrichmentIndices {
  <#
    .SYNOPSIS
        Rebuild all Enrichment indices associated with the specified Enrichment Policy
    .DESCRIPTION
        Each time the base/source index for an Enrichment Policy has documents added or updated, the system indices used to perform enrichment lookups need to be rebuilt.

        This operation triggers this task on the cluster.

        Optionally supports Authentication.
    .PARAMETER EsUrl
        Base URL for your ElasticSearch server/cluster
    .PARAMETER Policy
        Name of Enrichment Policy to rebuild enrichment indices for
    .PARAMETER EsCreds
        PSCredential object containing username and password to access ElasticSearch
    .INPUTS
        None
    .OUTPUTS
        Result of requested operation
    .EXAMPLE
        Rebuld enrichment indices associated to 'MyEnrichmentPolicy'

        PS C:\> $result = Update-EsEnrichmentIndices -EsUrl http://192.168.1.10:9200 -Policy 'MyEnrichmentPolicy'
    .LINK
        https://github.com/IPSecMSSP/Elastic.Helper
  #>


  [CmdletBinding(SupportsShouldProcess)]

  param (
    [string] [Parameter(Mandatory=$true)] $ESUrl,
    [string] [Parameter(Mandatory=$true)] $Policy,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  $Method = 'POST'
  $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy, "_execute")

  if($PSCmdlet.ShouldProcess($Uri)) {
    if ($EsCreds) {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -User $EsCreds.UserName -Password $EsCreds.Password  -SkipCertificateCheck| ConvertFrom-Json -depth 8
    } else {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json'  -SkipCertificateCheck| ConvertFrom-Json -depth 8
    }
  }

  return $Result
}
