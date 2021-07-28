# Execute Enrichment Policies tied to a specified index
function Update-EsEnrichmentIndicesFromIndex {

  [CmdletBinding(SupportsShouldProcess)]

  param(
      [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
      [string] [Parameter(Mandatory=$true)] $IndexName
  )

  # Look through the Enrich Policies in our configuraton
  foreach ($Policy in $EsConfig._enrich.policies) {
      # Find those that depend on our index
      if ($IndexName -match $Policy.definition.match.indices) {
          if ($PSCmdlet.ShouldProcess($Policy.name)) {
              # Update the Enrichment Index
              $msg = "Updating Enrichment Policy Index - Index: {0}; Policy: {1};" -f $IndexName, $Policy.name
              Write-Output $msg
              Update-EsEnrichmentIndices -ESUrl $EsConfig.eshome -Policy $Policy.name
          }
      }
  }
}
