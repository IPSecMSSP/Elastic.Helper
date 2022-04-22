# Test for Enrich Policy Dependencies
function Test-EsEnrichPolicyExists {
    <#
    .SYNOPSIS
        Test if the Enrichment Policy Exists.
    .DESCRIPTION
        Using the provided configuration definition, determine if the enrichment policy exists in ElasticSearch.

        Will check all defined enrichment policies unless one is specified.

        Checks ElasticSearch to confirm that the index on which the policy is based exists.
    .PARAMETER EsConfig
        ElasticHelper configuration loaded using Get-EsHelperConfig.
    .PARAMETER PolicyName
        (Optional) Name of Enrichment Policy to check for existence.

        If not specified, checks all defined Enrichment Policies.
    .PARAMETER EsCreds
        PSCredential object containing username and password to access ElasticSearch
    .INPUTS
        PSCustomObject -> Defined ElasticHelper Configuration
    .OUTPUTS
        Success (1) or Failure (0)
    .EXAMPLE
        Test all defined Enrichment Policies for existence

        PS C:\> $Result = Test-EsEnrichmentPolicyExists -EsConfig $EsConfig
    .EXAMPLE
        Test the MyEnrichmentPolicy Enrichment Policy for existence

        PS C:\> $Result = Test-EsEnrichmentPolicyExists -EsConfig $EsConfig -PolicyName 'MyEnrichmentPolicy'
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
      if ($EsCreds) {
        $RunningPolicy = Get-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name -EsCreds $EsCreds
      } else {
        $RunningPolicy = Get-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name
      }
      if ($RunningPolicy.policies.Count -eq 0) {
        $msg = "Unmet Dependency: Enrichment Policy {0} not loaded" -f $Policy.name
        Write-Error $msg
        WriteOutput $False
      } else {
        $msg = "Dependency Met: Enrichment Policy {0} loaded" -f $Policy.name
        Write-Verbose $msg
        Write-Output $True
      }
      Write-Debug $RunningPolicy | ConvertTo-Json
    }
  }
}
