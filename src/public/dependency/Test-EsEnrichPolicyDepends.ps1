# Test for Enrich Policy Dependencies
function Test-EsEnrichPolicyDepends {

  [CmdletBinding()]

  param(
      [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
      [string] [Parameter(Mandatory=$false)] $PolicyName
  )

  # Find the Enrichment Policy in the config

  foreach ($Policy in $EsConfig._enrich.policies) {
      # Check all policies if none specified, otherwise check just the one
      if(-not ($PSBoundParameters.ContainsKey('PolicyName')) -or $Policy.name -eq $PolicyName) {
          $EsIndex = $Policy.definition.match.indices
          $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $EsIndex

          if($EsIndexStatus.Error) {
              if ($EsIndexStatus.status -eq 404) {
                  $msg = "Unmet Dependency: Index {0} not found" -f $EsIndex
              } else {
                  $msg = "Error: {0}" -f $esIndexStatus.Error
              }
              Write-Output $msg
          } elseif ($EsIndexStatus.{$EsIndex}) {
              $RunningPolicy = Get-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name
              if ($RunningPolicy.policies.Count -eq 0) {
                  $msg = "Unmet Dependency: Enrichment Policy {0} not loaded" -f $Policy.name
              } else {
                  return 1
              }
          }
      }
  }
}
