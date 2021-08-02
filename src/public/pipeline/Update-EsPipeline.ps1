# Update the pipeline definition with a new one
function Update-EsPipeline {
  <#
  .SYNOPSIS
      Update the settings for the specified Pipeline with the provided definition.
  .DESCRIPTION
      Use the supplied Pipeline definition to update the existing settings of the specified Pipeline.

      If additional settings are present on the ElasticSearch Pipeline, the new settings will merge with and override existing settings.  Other settings will remain unchanged.

      This allows you to update just the 'number_of_replicas' setting without affecting any other settings.

      Optionally supports Authentication.
  .PARAMETER EsUrl
      Base URL for your ElasticSearch server/cluster
  .PARAMETER Pipeline
      Name of ElasticSearch Pipeline to update current configuration of.
  .PARAMETER PipelineDefinition
      PSCustomObject defining the desired state of the Pipeline configuration
  .PARAMETER EsCreds
      PSCredential object containing username and password to access ElasticSearch
  .INPUTS
      None
  .OUTPUTS
      Result of operation
  .EXAMPLE
      Update the Pipeline named MyPipeline without authentication

      PS C:\> $EnrichPol = Update-EsPipelineSettings -EsUrl http://192.168.1.10:9200 -Pipeline 'MyPipeline' -PipelineDefinition $PipelineDef
  .LINK
      https://github.com/jberkers42/Elastic-Helper
  #>

  [CmdletBinding(SupportsShouldProcess)]

  param (
    [string] [Parameter(Mandatory=$true)] $ESUrl,
    [string] [Parameter(Mandatory=$true)] $Pipeline,
    [Parameter(Mandatory=$true)] $PipelineDefinition,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  $Method = 'PUT'
  $Uri = [io.path]::Combine($ESUrl, "_ingest/pipeline/", $Pipeline)
  $EsBody = [Elastic.ElasticsearchRequestBody] $PipelineDefinition

  if($PSCmdlet.ShouldProcess($Uri)) {
    if ($EsCreds) {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody -User $EsCreds.UserName -Password $EsCreds.Password  -SkipCertificateCheck| ConvertFrom-Json -depth 8
    } else {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody  -SkipCertificateCheck| ConvertFrom-Json -depth 8
    }
  }

  if ($Result.acknowledged) {
    # Successfully deployed Pipeline Config
    return $Result.acknowledged
  } else {
    return $Result
  }
}
