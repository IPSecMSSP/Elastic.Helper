# Test for Enrich Policy Dependencies
function Test-EsEnrichPolicyDepends {
    <#
    .SYNOPSIS
        Test if the Enrichment Policy's Dependencies are met.
    .DESCRIPTION
        Using the provided configuration definition, determine if it's dependencies are met in ElasticSearch.

        Will check all defined enrichment policies unless one is specified.

        Checks ElasticSearch to confirm that the index on which the policy is based exists.
    .PARAMETER EsConfig
        ElasticHelper configuration loaded using Get-EsHelperConfig.
    .PARAMETER PolicyName
        (Optional) Name of Enrichment Policy to check for unmet dependencies.

        If not specified, checks all defined Enrichment Policies.
    .PARAMETER EsCreds
        PSCredential object containing username and password to access ElasticSearch
    .INPUTS
        PSCustomObject -> Defined ElasticHelper Configuration
    .OUTPUTS
        Success (1) or Failure (0)
    .EXAMPLE
        Test all defined Enrichment Policies for Dependencies

        PS C:\> $Result = Test-EsEnrichmentPolicyDepends -EsConfig $EsConfig
    .EXAMPLE
        Test the MyEnrichmentPolicy Enrichment Policy for Dependencies

        PS C:\> $Result = Test-EsEnrichmentPolicyDepends -EsConfig $EsConfig -PolicyName 'MyEnrichmentPolicy'
    .LINK
        https://github.com/jberkers42/Elastic.Helper
    #>

  [CmdletBinding()]

  param(
    [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
    [string] [Parameter(Mandatory=$false)] $PolicyName,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

# Find the Enrichment Policy in the config

  foreach ($Policy in $EsConfig._enrich.policies) {
    # Check all policies if none specified, otherwise check just the one
    if(-not ($PSBoundParameters.ContainsKey('PolicyName')) -or $Policy.name -eq $PolicyName) {
      $EsIndex = $Policy.definition.match.indices
      Write-Debug "  Checking Index: $EsIndex"
      if ($EsCreds) {
        $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $EsIndex -EsCreds $EsCreds
      } else {
        $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $EsIndex
      }

      Write-Debug "Index Status: $EsIndexStatus"
      if($EsIndexStatus.Error) {
        if ($EsIndexStatus.status -eq 404) {
            $msg = "Unmet Dependency: Index {0} not found" -f $EsIndex
        } else {
            $msg = "Error: {0}" -f $esIndexStatus.Error
        }
        Write-Output $msg
      } elseif ($EsIndexStatus.$EsIndex) {
        Write-Debug "  Index $EsIndex Present..."
        if ($EsCreds) {
          $RunningPolicy = Get-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name -EsCreds $EsCreds | ConvertFrom-Json -Depth 8
        } else {
          $RunningPolicy = Get-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name | ConvertFrom-Json -Depth 8
        }
        if ($RunningPolicy.policies.Count -eq 0) {
          $msg = "Unmet Dependency: Enrichment Policy {0} not loaded" -f $Policy.name
          Write-Error $msg
        } else {
          $msg = "Dependency Met: Enrichment Policy {0} loaded" -f $Policy.name
          Write-Debug $msg
        }
      }
    }
  }
}
