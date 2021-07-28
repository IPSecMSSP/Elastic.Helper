# Test Pipeline Dependencies
function Test-EsPipelineDepends {

  [CmdletBinding()]

  param(
      [PsCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
      [string] [Parameter(Mandatory=$false)] $PipelineName
  )

  # Find the pipeline in the config
  foreach($Pipeline in $EsConfig._ingest.pipelines) {
      # Check all pipelines if none specified, otherwise check just the one
      if (-not ($PSBoundParameters.ContainsKey('PipelineName')) -or $Pipeline.name -eq $PipelineName) {
          foreach($PipelineProcessor in $Pipeline.definition.processors) {
              if ($PipelineProcessor.enrich) {
                  $EnrichPolicy = $PipelineProcessor.enrich.policy_name
                  $EnrichPolicyDepends = Test-EsEnrichPolicyDepends -EsConfig $EsConfig -PolicyName $EnrichPolicy
                  if ($null -eq $EnrichPolicyDepends){
                      # Dependencies matched
                      $PipelineStatus = Get-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline.name | ConvertFrom-Json
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
