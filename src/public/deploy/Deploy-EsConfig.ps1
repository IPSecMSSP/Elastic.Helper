# Deploy ElasticSearch Configuration
# But only for resources that do not have dependencies, or where these dependencies are met
function Deploy-EsConfig {
  <#
  .SYNOPSIS
    Deploy specified ElasticSearch Resources to ElasticSearch cluster, with dependency checks.
  .DESCRIPTION
    Using the provided configuration definition, deploy the defined resources to ElasticSearch.

    Will check all dependencies are met before deploying to ElasticSeach, and will not attempt deployment of resources for which dependencies are not met.

    This may be used iteratively to defined the required resouces in ElasticSearch as data is populated.
  .PARAMETER EsConfig
    ElasticHelper configuration loaded using Get-EsHelperConfig.
  .PARAMETER ResourceType
    (Not Yet Implemented)
    (Optional) Type of Resources to deploy to ElasticSearch.

    One of: (index, pipeline, enrichmentpolicy)

    If not specified, attempts to deploy all resources without unmet dependencies.
  .PARAMETER ResourceName
    (Not Yet Implemented)
    (Optional) Name of Resource to deploy to ElasticSearch.  If specified, must also specify resource type.

    If not specified, attempts to deploy all resources without unmet dependencies.
  .PARAMETER EsCreds
    PSCredential object containing username and password to access ElasticSearch
  .INPUTS
    PSCustomObject -> Defined ElasticHelper Configuration
  .OUTPUTS
    Success (1) or Failure (0)
  .EXAMPLE
    Deploy all defined Resources to ElasticSearch

    PS C:\> $Result = Deploy-EsConfig -EsConfig $EsConfig
  .EXAMPLE
    Load Configuration file 'elasticproject.json' from '/opt/scripts/project/etc'

    PS C:\> $EsConf = Get-EsHelperConfig -ConfigName elasticproject -Path '/opt/scripts/project/etc'
  .LINK
    https://github.com/IPSecMSSP/Elastic.Helper
  #>

  [CmdletBinding()]

  param(
    [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
    [string] [Parameter(Mandatory=$false)] $ResourceType,
    [string] [Parameter(Mandatory=$false)] $ResourceName,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  if ($PSBoundParameters.ContainsKey('ResourceType')) {
    if($PSBoundParameters.ContainsKey('ResourceName')) {
      # Process just the single Resource
    } else {
      # Can't have resource Type without Resource name
      Write-Error "Both ResourceType and ResourceName need to be specified"
    }
  } else {
    # In order, we need to do:
    # * Pipeline
    # * Index
    # * Enrichment Policy

    # Pipelines
    foreach ($Pipeline in $EsConfig._ingest.pipelines) {
      # Check dependencies
      if ($EsCreds) {
        $PipelineStatus = Test-EsPipelineDepends -EsConfig $EsConfig -PipelineName $Pipeline.name -EsCreds $EsCreds
      } else {
        $PipelineStatus = Test-EsPipelineDepends -EsConfig $EsConfig -PipelineName $Pipeline.name
      }
      if ($null -eq $PipelineStatus) {
        # Dependency check passed
        $msg = "Deploying Pipeline: {0}" -f $PipeLine.name
        Write-Output $msg
        if ($EsCreds) {
          $result = Update-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline.name -PipelineDefinition ($PipeLine.definition | ConvertTo-Json -Depth 8) -EsCreds $EsCreds
        } else {
          $result = Update-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline.name -PipelineDefinition ($PipeLine.definition | ConvertTo-Json -Depth 8)
        }
        if ($result) {
          $msg = "Pipeline Deployed: {0}" -f $PipeLine.name
        } else {
          $msg = "Pipeline Deployment Failed: {0} - {1}" -f $PipeLine.name, $result
        }
        Write-Output $msg
      } else {
        # Dependency check failed
        $msg = "Pipeline Deployment Skipped: {0} - Dependencies not met.`n  {1}" -f $PipeLine.name, $PipelineStatus
        Write-Output $msg
      }
    }

    # Indices
    # We don't actually deploy indices, these are written by the data insert process

    # Enrichment Policies
    foreach ($Policy in $EsConfig._enrich.policies) {
      # Check Dependencies
      if ($EsCreds) {
        $PolicyStatus = Test-EsEnrichPolicyDepends -EsConfig $EsConfig -PolicyName $Policy.name -EsCreds $EsCreds
      } else {
        $PolicyStatus = Test-EsEnrichPolicyDepends -EsConfig $EsConfig -PolicyName $Policy.name
      }
      if ($null -eq $PolicyStatus) {
        # Dependency Check Passed
        $msg = "Deploying Enrichment Policy: {0}" -f $Policy.name
        Write-Output $msg
        if ($EsCreds) {
          $result = Update-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name -PolicyDefinition ($Policy.definition | ConvertTo-Json -Depth 8) -EsCreds $EsCreds
        } else {
          $result = Update-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name -PolicyDefinition ($Policy.definition | ConvertTo-Json -Depth 8)
        }
        if ($result) {
          $msg = "Enrichment Policy Deployed: {0}" -f $Policy.name
        } else {
          $msg = "Enrichment Policy Deployment Failed: {0} - {1}" -f $Policy.name, $result
        }
        Write-Output $msg
      } else {
        # Dependency Check failed
        $msg = "Enrichment Policy Deployment Skipped: {0} - Dependencies not met.`n  {1}" -f $Policy.name, $PolicyStatus
        Write-Output $msg
      }
    }
  }
}
