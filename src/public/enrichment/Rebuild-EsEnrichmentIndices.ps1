# Rebuild Enrichment Indices
function Update-EsEnrichmentIndices {

  [CmdletBinding(SupportsShouldProcess)]

  param (
      [string] [Parameter(Mandatory=$true)] $ESUrl,
      [string] [Parameter(Mandatory=$true)] $Policy
  )

  $Method = 'POST'
  $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy, "_execute")

  if($PSCmdlet.ShouldProcess($Uri)) {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' | ConvertFrom-Json -depth 8
  }

  return $Result
}
