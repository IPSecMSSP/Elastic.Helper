# Test Pipeline Dependencies
function Test-EsPipelineDepends {
    <#
    .SYNOPSIS
        Test if the Pipeline's Dependencies are met.
    .DESCRIPTION
        Using the provided configuration definition, determine if it's dependencies are met in ElasticSearch.

        Will check all defined pipelines unless one is specified.

        Checks ElasticSearch to confirm that the pipeline, and associated dependencies exist.
    .PARAMETER EsConfig
        ElasticHelper configuration loaded using Get-EsHelperConfig.
    .PARAMETER PipelineName
        (Optional) Name of Pipeline to check for unmet dependencies.

        If not specified, checks all defined Pipelines.
    .PARAMETER EsCreds
        PSCredential object containing username and password to access ElasticSearch
    .INPUTS
        PSCustomObject -> Defined ElasticHelper Configuration
    .OUTPUTS
        Success (1) or Failure (0)
    .EXAMPLE
        Test all defined Pipelines for Dependencies

        PS C:\> $Result = Test-EsPipelineDepends -EsConfig $EsConfig
    .EXAMPLE
        Test the MyPipeline Pipeline for Dependencies

        PS C:\> $Result = Test-EsPipelineDepends -EsConfig $EsConfig -PipelineName 'MyPipeline'
    .LINK
        https://github.com/jberkers42/Elastic-Helper
    #>

  [CmdletBinding()]

  param(
    [PsCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
    [string] [Parameter(Mandatory=$false)] $PipelineName,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
)

  # Find the pipeline in the config
foreach($Pipeline in $EsConfig._ingest.pipelines) {
    # Check all pipelines if none specified, otherwise check just the one
  if (-not ($PSBoundParameters.ContainsKey('PipelineName')) -or $Pipeline.name -eq $PipelineName) {
    foreach($PipelineProcessor in $Pipeline.definition.processors) {
      if ($PipelineProcessor.enrich) {
        $EnrichPolicy = $PipelineProcessor.enrich.policy_name
        if ($EsCreds) {
          $EnrichPolicyDepends = Test-EsEnrichPolicyDepends -EsConfig $EsConfig -PolicyName $EnrichPolicy -EsCreds $EsCreds
        } else {
          $EnrichPolicyDepends = Test-EsEnrichPolicyDepends -EsConfig $EsConfig -PolicyName $EnrichPolicy
        }
        if ($null -eq $EnrichPolicyDepends){
          # Dependencies matched
          if ($EsCreds) {
            $PipelineStatus = Get-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline.name -EsCreds $EsCreds|  ConvertFrom-Json -Depth 8
          } else {
            $PipelineStatus = Get-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline.name | ConvertFrom-Json -Depth 8
          }
          if($PipelineStatus.($Pipeline.name)) {
            # Pipeline is there
          } else {
            $msg = "Unmet Dependency: Pipeline {0} not loaded" -f $Pipeline.name
            Write-Output $msg
          }
        } else {
          $msg = "Unmet Dependencies for Pipeline: {0} - " -f $Pipeline.Name
          $msg += $EnrichPolicyDepends
          Write-Output $msg
        }
      }
    }
  }
}
}
