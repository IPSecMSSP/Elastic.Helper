# Update the Enrichment Policy
function Update-EsEnrichmentPolicy {
  <#
  .SYNOPSIS
      Update the definition of the specified Enrichment Policy with the provided definition.
  .DESCRIPTION
      Use the supplied policy definition to update the running policy for the specified enrichment policy.

      Optionally supports Authentication.
  .PARAMETER EsUrl
      Base URL for your ElasticSearch server/cluster
  .PARAMETER Policy
      Name of ElasticSearch Enrichment Policy to get current configuration of.
  .PARAMETER PolicyDefinition
      PSCustomObject defining the desired state of the policy definition
  .PARAMETER EsCreds
      PSCredential object containing username and password to access ElasticSearch
  .INPUTS
      None
  .OUTPUTS
      Definition of current Enrichment Policy on ElasticSearch Cluster
  .EXAMPLE
      Update the Enrichment Policy named MyEnrichmentPolicy without authentication

      PS C:\> $EnrichPol = Update-EsEnrichmentPolicy -EsUrl http://192.168.1.10:9200 -Policy 'MyEnrichmentPolicy' -PolicyDefinition $PolicyDef
  .LINK
      https://github.com/jberkers42/Elastic.Helper
  #>

  [CmdletBinding(SupportsShouldProcess)]

  param (
    [string] [Parameter(Mandatory=$true)] $ESUrl,
    [string] [Parameter(Mandatory=$true)] $Policy,
    [Parameter(Mandatory=$true)] $PolicyDefinition,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  $Method = 'PUT'
  $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy)
  $EsBody = [Elastic.ElasticsearchRequestBody] $PolicyDefinition

  if($PSCmdlet.ShouldProcess($Uri)) {
    if ($EsCreds) {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody -User $EsCreds.UserName -Password $EsCreds.Password  -SkipCertificateCheck| ConvertFrom-Json -depth 8
    } else {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody  -SkipCertificateCheck| ConvertFrom-Json -depth 8
    }
  }

  return $Result.acknowledged
}
