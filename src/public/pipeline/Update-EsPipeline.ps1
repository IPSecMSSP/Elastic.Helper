# Update the pipeline definition with a new one
function Update-EsPipeline {
  [CmdletBinding(SupportsShouldProcess)]
  param (
      [string] [Parameter(Mandatory=$true)] $ESUrl,
      [string] [Parameter(Mandatory=$true)] $Pipeline,
      [Parameter(Mandatory=$true)] $PipelineDefinition
  )

  $Method = 'PUT'
  $Uri = [io.path]::Combine($ESUrl, "_ingest/pipeline/", $Pipeline)
  $EsBody = [Elastic.ElasticsearchRequestBody] $PipelineDefinition

  if($PSCmdlet.ShouldProcess($Uri)) {
      $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody | ConvertFrom-Json -depth 8
  }

  return $Result.acknowledged
}
