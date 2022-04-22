# Test Pipeline Dependencies
function Test-EsPipelineExists {
  <#
  .SYNOPSIS
      Test if the Pipeline exists.
  .DESCRIPTION
      Using the provided configuration definition, determine if it exists in ElasticSearch.

      Will check all defined pipelines unless one is specified.

      Checks ElasticSearch to confirm that the pipeline exists.
  .PARAMETER EsConfig
      ElasticHelper configuration loaded using Get-EsHelperConfig.
  .PARAMETER PipelineName
      (Optional) Name of Pipeline to check for existence.

      If not specified, checks all defined Pipelines.
  .PARAMETER EsCreds
      PSCredential object containing username and password to access ElasticSearch
  .INPUTS
      PSCustomObject -> Defined ElasticHelper Configuration
  .OUTPUTS
      $true if pipeline exists, $false if not
  .EXAMPLE
      Test all defined Pipelines for existence

      PS C:\> $Result = Test-EsPipelineExists -EsConfig $EsConfig
  .EXAMPLE
      Test the MyPipeline Pipeline for existence

      PS C:\> $Result = Test-EsPipelineExists -EsConfig $EsConfig -PipelineName 'MyPipeline'
  .LINK
      https://github.com/jberkers42/Elastic.Helper
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
      Write-Verbose "Testing existence of Pipeline: $($Pipeline.name)"
      if ($EsCreds) {
        $PipelineStatus = Get-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline -EsCreds $EsCreds
      } else {
        $PipelineStatus = Get-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline -EsCreds $EsCreds
      }

      if ($PipelineStatus.($Pipeline.name)) {
        Write-Verbose "Pipeline exists: $($Pipeline.name)"
        Write-Output $true
      } else {
        Write-Verbose "Pipeline does not exist: $($Pipeline.name)"
        Write-Output $false
      }

      Write-Debug ($PipelineStatus | ConvertTo-Json -depth 10)
    }
  }
}
