# Update the Enrichment Policy
function Update-EsEnrichmentPolicy {

  [CmdletBinding(SupportsShouldProcess)]

  param (
      [string] [Parameter(Mandatory=$true)] $ESUrl,
      [string] [Parameter(Mandatory=$true)] $Policy,
      [Parameter(Mandatory=$true)] $PolicyDefinition
  )

  $Method = 'PUT'
  $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy)
  $EsBody = [Elastic.ElasticsearchRequestBody] $PolicyDefinition

  if($PSCmdlet.ShouldProcess($Uri)) {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody | ConvertFrom-Json -depth 8
  }

  return $Result.acknowledged
}
